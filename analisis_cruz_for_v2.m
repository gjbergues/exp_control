%ANTIHORARIO

function  [BVVt,BHHt,IV,IH]=analisis_cruz_for_v2(k,h)

    NI = 20;%Numero de imagenes a ser 	promediadas.Etiquetadas consecutivamente
	sum_I = 0;
	SumaTotal = 0;
    n = 5; %nº de cortes de gaussianas
	
    d = 51-k; %Para cuando es el sentido horario, empiezo del directorio 50
    
	for i=1:NI
 
       
        if h==1
            f=['I:\EXP4\ahorario\p' num2str(k-1) '\ima' num2str(i) '.bmp'];
            %f=['J:\DATOS\TECNOLOGICA\datos_paper_pattern\Exp 2\ahorario\p' num2str(k-1) '\ima' num2str(i) '.bmp'];
        end
        
        if h==0
            f=['I:\EXP4\horario\p' num2str(d) '\ima' num2str(i) '.bmp'];
            %f=['J:\DATOS\TECNOLOGICA\datos_paper_pattern\Exp 2\horario\p' num2str(d) '\ima' num2str(i) '.bmp'];
        end
        
        %bmp ingresa color por canal? o mezcla colores?
 
        rgb_img = imread(f);
 
    	I = .2989*rgb_img(:,:,1)+.5870*rgb_img(:,:,2) +.1140*rgb_img(:,:,3);
 
        sum_I = sum_I+(double(I)+1);
 
	end
 
	I_new = sum_I/(NI);
	I_new_neg = 1-(I_new./255);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA VERTICAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	yy = 1:200;
	xx = 1:200;
    
    xminh= 550-k*2;
    yminh = 870-k*14;
    
    II = imcrop(I_new_neg,[xminh yminh 199 199]);%[xmin ymin width height]% 
    
	%figure; imagesc(II); colormap(gray)% para ver cada corte
    
    %Creo con cftool el fitting del fondo
	[fitresult, gof] = Fit_fondo_cruz_H(xx, yy, II);
    %figure; surf(xx, yy, II);
    
    [t1,t2] = meshgrid( xx,yy);
    promfit = fitresult( t1, t2);
    %figure; surf(t1, t2, promfit);

    J2 = abs(promfit-II);
    %figure; imagesc(J2); colormap(gray)
    %figure; surf(xx, yy, J2);
    
        
    for j = 1:n
      cv2 = squeeze(J2(:,j));
      [fit3, gof3] =  Fit_un_paso_Gauss_CRUZ_H(xx', cv2);
 
      ch2 = coeffvalues(fit3);
      cih = confint(fit3, 0.95);
 
      BHH(j) = ch2(2); %valor central de la gaussiana para cada corte
      IH(j) = (cih(2,2)-cih(1,2))/2; %incertidumbre para cada corte
    end

    %mdlV = LinearModel.fit(1:5, BHH); 
    %figure; plot(mdlV)
 
    %Regregresión
    %X = [ones(1,5)' (1:5)'];
    %[bv, bintv, rv, rintv] = regress(BHH', X);
    %BHHt=bv(1)+635-(k-1)*6;

    %Promedio
    BHHt = sum(BHH)/n + 870-k*14;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% LINEA VERTICAL DE LA CRUZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    yy = 1:200;
    xx = 1:200;
    
    xmin= 750-k*2;
    ymin = 970-k*13;
    III = imcrop(I_new_neg,[xmin ymin 199 199]);%[xmin ymin width height]% 
    %figure; imagesc(III); colormap(gray)% para ver cortes

    [fitresult2, gof2] = Fit_fondo_cruz_V(xx, yy, III);
    [t1,t2] = meshgrid( xx,yy);
    promfit2 = fitresult2( t1, t2);
    J = abs(promfit2-III);
    %figure; surf(xx, yy, J); 

    for j = 1:n
        cv2=squeeze(J(j,:))';
 
        [fit4, gof4] =  Fit_un_paso_Gauss_CRUZ_V(yy', cv2);
 
        cV2 = coeffvalues(fit4);
        ciV = confint(fit4, 0.95);
 
        IV(j) = (ciV(2,2)-ciV(1,2))/2;
        BVV(j) = cV2(2);
    end

    BVVt = sum(BVV)/n + xmin;
