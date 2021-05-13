clear; close all; clc;
%% Histogram Equalization (HE) algorithm 
img = imread('example.png'); 
[M,N]=size(img);
H=imhist(img); 
H=H/(M*N);
%compute the mapping function
for L = 1:256
     G(L)=uint8(sum(H(1:L))*255);
end
%perform mapping
outimg=img;
for i = 1:M
     for j=1:N
          f=img(i,j) +1;
          outimg(i,j)=G(f);
     end
end
H_after=imhist(outimg); 
H_after=H_after/(M*N);
%% Visualization
figure, subplot(2,3,1), imshow(img), title('Original Image');
subplot(2,3,2), bar(H), title('Original Histgram');
subplot(2,3,3), plot(G), title('Mapping Function');
subplot(2,3,4), imshow(outimg), title('HE-Enhanced Image');
subplot(2,3,5), bar(H_after), title('HE-Enhanced Histgram');