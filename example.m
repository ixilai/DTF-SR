
close all;

I = im2double(imread('1.tif'));

tic;
res = RollingGuidanceFilter(I,3,0.05,4);
I2=I-res;
toc;

%figure,imshow(I);
%figure,imshow(I2);
%figure,imshow(res);
imwrite(I2,'E:\1111\3.tif');
imwrite(res,'E:\1111\4.tif');