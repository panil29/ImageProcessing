%%%%% This is a Matlab Assignement-2, CIS-694, 03/07/2021
%%%%% Name: Anil Pavuluru
%%%%% csu id:2782551
%%%%% a.pavuluru@vikes.csuohio.edu
%%%%% ---------------------------------------------------------------------
%% 
clear all;      
close all;       
clc;     
%% food mapping food.jpg
% reading the image values max and min values of single channel 
% After call mapping function logic for image enhancement of good image
% display original and mapping image both side by side 
food = imread('Food.jpg');
Max = 255;
Min = 0;
scaledfood = Mapping(food,[Min,Max]);
figure,
subplot(1,2,1);
imshow(food);
title('Original Food Image');
subplot(1,2,2);
imshow(scaledfood);
title('Scaled Food Image');
disp('-----Done for Question 1-----');
pause;
%% Average filtering circuit.jpg
% Average mask by 3*3 and next 5*5 matrix
Im = imread('Circuit.jpg');
mask1 = ones(3)*(1/(3*3));
filteredIm1 = AverageFiltering(Im, mask1);
mask2 = ones(5)*(1/(5*5));
filteredIm2 = AverageFiltering(Im, mask2);
figure,
subplot(2,2,1);
imshow(Im);
title('Circuit Original Image');
subplot(2,2,2);
imshow(filteredIm1);
title('Circuit Average Filtered Image with 3x3 Mask');
subplot(2,2,3);
imshow(filteredIm2);
title('Circuit Average Filtered Image with 5x5 Mask');
disp('-----Done for Question 2-----');
pause;
%% Median Filtering circuit.jpg
% Median mask by 3*3 and next 5*5 matrix
Im = imread('Circuit.jpg');
mask1 = ones(3);
filteredIm1 = MedianFiltering(Im, mask1);
mask2 = ones(5);
filteredIm2 = MedianFiltering(Im, mask2);
figure,
subplot(2,2,1);
imshow(Im);
title('Circuit Original Image');
subplot(2,2,2);
imshow(filteredIm1);
title('Circuit Median Filtered Image with 3x3 Mask');
subplot(2,2,3);
imshow(filteredIm2);
title('Circuit Median Filtered Image with 5x5 Mask');
disp('-----Done for Question 3-----');
pause;
%% Laplacian moon image
% filtred,scaled filter,enhancement of moon 
Im = imread('Moon.jpg');
p= fspecial('laplacian');
filteredIm = imfilter(Im,p);
scaledfilteredIm = Mapping(Im, [Min,Max]);
enhancedIm = Im - filteredIm;
figure,
subplot(2,2,1);
imshow(Im);
title('Original MOON Image');
subplot(2,2,2);
imshow(filteredIm);
title('Filtered MOON Image');
subplot(2,2,3);
imshow(scaledfilteredIm);
title('Scaled Filtered MOON Image');
subplot(2,2,4);
imshow(enhancedIm);
title('Enhanced MOON Image');
disp('-----Done for Question 4-----');
pause;


