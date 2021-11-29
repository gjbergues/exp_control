function [snr,snr2 ] = SN
%Valores obtenidos snr(con fondo)=1.5
%snr2(sin fondo)= 17,68

y = 1:186; %filas
x = 1:327; %columnas
load('imsinfondo.mat');
I= imread('ima1.bmp');
I = rgb2gray(I);
I = imcomplement(I);
%II=zeros(327, 186);
%II = I(822+x, 750+y); 
In = imcrop(I,[822 750 327 186]);
figure; imshow(In);
n=mean(mean(In));

Is = imcrop(I,[474 623 4 60]);%[xmin ymin width height]% 
figure; imshow(Is);
s=mean(mean(Is));
snr=10*log10(s/n);

%Imagen sin fondo
Ins = imcrop(J,[163 15 49 15]);
figure; imshow(Ins);
ns=mean(mean(Ins));

Iss = imcrop(J,[132 13 3 17]);
figure; imshow(Iss);
ss=mean(mean(Iss));
snr2=10*log10(ss/ns);
end

