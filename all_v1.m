%hace todo el procedimienot dependiendo si es horario o antihorario
%horario=0;
%antihorio=1;
function [medh, posh, medv, posv]=all_v1(h)
%     clear all
%     close all

    ND = 51;

    for k = 1:ND % numero de directorios
	
        [BVV,BHH,IV,IH] = analisis_cruz_for_v2(k,h);
 
         BVV2(k) = BVV;
         BHH2(k) = BHH;
         IV2(k,:) = IV;
         IH2(k,:) = IH;
    end
 
    %Resultado de mediciones
    
    %Medición de las posiciones HORIZONTALES de la cruz
    posh = BHH2;
    for i = 1:ND
        medh(i) = (-(BHH2(i)-BHH2(1)))*60/97.3;        
    end    
    %Medición de las posiciones VERTICALES de la cruz
    posv = BVV2;
    for j = 1:ND
        medv(j) = (-(BVV2(j)-BVV2(1)))*60/97.3;        
    end
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%ESCRITURA EN EXCEL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %ANTIHORARIO
 if (h==1)
    nah=xlsread('nivel.xls','B3:B53');%med nivel antihorario
    nahref= (nah-nah(1));%referencio el nivel a la primera medición
    xlswrite('nivel.xls',nahref,1,'C3:C53');%escribo en tabla
    xlswrite('nivel.xls',medh',1,'D3:D53');%coloco medición con interfaz
    difah = nahref+medh';%hago la diferencia entre nivel-autocolimador
    xlswrite('nivel.xls',difah,1,'E3:E53');%escribo diferencia
    xlswrite('nivel.xls',medv',1,'F3:F53');%valores verticales
 end
 
 %%HORARIO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if (h==0)
    nh = xlsread('nivel.xls','I3:I53');%med nivel horario
    nhref = nh - nh(1);
    xlswrite('nivel.xls',nhref,1,'J3:J53');
    xlswrite('nivel.xls',medh',1,'K3:K53');%coloco medición con interfaz
    difh = nhref+medh';%hago la diferencia entre nivel-autocolimador
    xlswrite('nivel.xls',difh,1,'L3:L53');%escribo diferencia
    xlswrite('nivel.xls',medv',1,'M3:M53');%valores verticales
 end
 
 
end%FINAL FUNCIÓN