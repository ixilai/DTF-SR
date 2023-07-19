clc;
clear all;
close all;


f1=imread("c08_1.bmp");
f2=imread("c08_2.bmp"); 
f1=im2double(f1);
f2=im2double(f2);
if size(f1,3)>1
    f1=rgb2gray(f1);     
end
if size(f2,3)>1
    f2=rgb2gray(f2);           
end

%figure,imshow(f1);   figure,imshow(f2);
D=cell2mat(struct2cell(load('Dzq.mat')));


%%
lambda = 1;  
npad = 10;    

[lowpass1, high1] = lowpass(f1, lambda, npad);
[lowpass2, high2] = lowpass(f2, lambda, npad);

%% lowpass fusion
% Smoothing
GA = im2double(lowpass1);
GB = im2double(lowpass2);
%figure,imshow(GA);figure,imshow(GB);

r = 3;
h = [1 -1];
[hei, wid] = size(GA);
N = boxfilter(ones(hei, wid), r);
Ga= RollingGuidanceFilter(GA,3,0.05,7);
Gb= RollingGuidanceFilter(GB,3,0.05,7);

%%
MA = abs(conv2(Ga,h,'same')) + ...
     abs(conv2(Ga,h','same'));
MB = abs(conv2(Gb,h,'same')) + ...
     abs(conv2(Gb,h','same'));
%figure,imshow(MA);figure,imshow(MB);
d = MA - MB;
%figure,imshow(d);
IA = boxfilter(d,r) ./ N>0;
IB=1-IA;
%%
for t = 1:6
            IA = double(IA > 0.5);
            IA = RF(IA, 15 , 0.3, 1, GA);
end
IB=1-IA;

%%
fused_low=im2double(lowpass1).*IA+IB.*im2double(lowpass2);
%figure,imshow(fused_low);
%%  highpass fusion
overlap=7;   
epsilon=0.01;  

fused_high=sparse_fusion(high1,high2,D,overlap,epsilon);
F=fused_high+fused_low;
figure,imshow(F);