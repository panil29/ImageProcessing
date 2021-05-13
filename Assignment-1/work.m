%%%%% This is a Matlab Assignement-1, CIS-694, 02/10/2021
%%%%% Name: Anil Pavuluru
%%%%% csu id:2782551
%%%%% a.pavuluru@vikes.csuohio.edu
%%%%% ---------------------------------------------------------------------
%% 
clear all;      
close all;       
clc;            
%% read rgb image of peppers
A = imread('peppers.bmp');

%plot for RGB IMAGE 'PEPPERS.bmp'
figure, 
subplot(1,1,1),
imshow(A), 
title('Original RGB color image');
disp('-----Done for Question 1-----');
pause;
%% convert image A into grayscale and store it as B

B=rgb2gray(A);
TB= B';
VB = flipud(B);
HB=fliplr(B);
% maximum,minimum,mean and median values
Max = max(max(B)) 
Min = min(min(B)) 
Mean = mean(mean(B))
Median = median(median(B)) 

%Plots for gray scale image
figure,
subplot(2,2,1), 
imshow(B), 
title('B'); 
%Transpose of image 'B'
subplot(2,2,2), 
imshow(TB), 
title('TB'); 
%updown of image 'B'
subplot(2,2,3), 
imshow(VB), 
title('VB'); 
%leftright of image 'B'
subplot(2,2,4), 
imshow(HB), 
title('HB'); 
disp('-----Done for Question 2-----');
pause;
%% normalized grayscale image

C = double(B - min(min(B)));
C = double(C/ max(max(C)));

%plots
title('Normalized Grayscale Image');
figure, 
subplot(1,1,1),
imshow(C),
imwrite(C, 'Anil Pavuluru_C.png');
disp('-----Done for Question 3-----');
pause;
%% “My method bw1” , and Matlab method bw2”, respectively. 
bw1=C;
bw1(C>0.4)=1;
bw1(C<0.4)=0;
bw2=im2bw(C,0.4);
   figure,
   subplot(1,2,1),
   imshow(bw1),
   title('My method bw1');
   subplot(1,2,2),
   imshow(bw2),
   title('My method bw2');
   if(bw1==bw2)
    disp("Images of bw1 and bw2 are same");
   else
    disp("Images of bw1 and bw1 are not same");
end
disp('-----Done for Question 4-----');
pause;
%% MY blur
 A2 = MyBlur(A);
 B2 = MyBlur(B);
%rgb image 'A'
figure,
subplot(2,2,1), 
imshow(A),
title ('A');
%gray scale image 'B'
subplot(2,2,2),
imshow(B),
title ('B');
%blured rgb image 'A2'
subplot(2,2,3),
imshow(A2),
title ('A2');
%blured grayscale image 'B2'
subplot(2,2,4), 
imshow(B2),
title ('B2');
disp('-----Done for Question 5-----');
pause; 
