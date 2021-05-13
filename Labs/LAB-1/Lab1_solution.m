clear all;
close all;
clc;
%% Q1-Task A: basic programming
V1=rand(1000,1);
V2=rand(1000,1);
L1=0;
L2=0;
for i=1:length(V1)
   L1=L1+abs(V1(i)-V2(i));
   L2=L2+(V1(i)-V2(i))^2;
end
L1
L2=sqrt(L2)
%% Q1-Task B: Vectorized Programming 
L1_v=sum(abs(V1-V2))
L2_v=sqrt(sum((V1-V2).^2))
%% Q2: Image Parsing 
JPGFile=dir(['Input/*.png']); 
ImageNum=size(JPGFile,1);
for i=1:ImageNum
    I=imread(['Input/' JPGFile(i).name]);
    [pathstr,name,ext] =fileparts(JPGFile(i).name);
    [row, col, dim]=size(I);
    I_s = imresize(I, [row/2, col/2]);
    imwrite(I_s,['Output/' name '.jpg']);
end