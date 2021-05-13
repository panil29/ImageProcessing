clear all;clc;close all;
K=5;
r=300, c=300;
method=2;         % different methods for the MyColorHist function 
path='database/'; % assume that each image in the database is a RGB color image
%% color histogram as feature for image retrieval 
interest=imread('interest.png');
H0=MyColorHist(interest, r, c, method);

JPGFile=dir([path '*.png']); 
ImageNum=size(JPGFile,1);

for i=1:ImageNum
    I=imread([path JPGFile(i).name]);
    Hi=MyColorHist(I, r, c, method);
    dist(i)=sqrt(sum((H0-Hi).^2));
end
[small_distance, return_id] = mink(dist, K); % return_id stores the returned K image index with minimum L2 distance
%% visualization 
figure, 
for j=1:K
    I=imread([path JPGFile(return_id(j)).name]);
    subplot(1,K,j), imshow(I,[]), title(JPGFile(return_id(j)).name);  
end
