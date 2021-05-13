clear all;
close all;
clc
%% binary mask as input 
I=imread('data/2400835220_0911e562a4.jpg'); 
mask=imread('data/2400835220_0911e562a4_mask.jpg'); 
mask=im2bw(mask,0.5);  
[SegMask,SegResult,e] = SecondGrabCut(I,mask,5);
figure, subplot(2,2,1), imshow(I,[]);
subplot(2,2,2), imshow(mask,[]);
subplot(2,2,3), imshow(SegMask,[]);
subplot(2,2,4), imshow(SegResult,[]);

%% saliency map as input for mask
I=imread('data/0007.jpg'); 
map=imread('data/0007_dcl.png'); 
mask=im2bw(map,0.3);  
[SegMask,SegResult,e] = SecondGrabCut(I,mask,5); 
figure, subplot(2,2,1), imshow(I,[]);
subplot(2,2,2), imshow(map,[]);
subplot(2,2,3), imshow(SegMask,[]);
subplot(2,2,4), imshow(SegResult,[]); 