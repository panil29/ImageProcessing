%%%%% This is a Matlab Midterm Answers, CIS-694, 03/15/2021
%%%%% Name: Anil Pavuluru
%%%%% csu id:2782551
%%%%% a.pavuluru@vikes.csuohio.edu
%%%%% ---------------------------------------------------------------------
%% preparation, do not modify this part
clear all;
clc;
close all;
I=imread('rice.png');
%% rice segmentation, rice detection, draw the tight bounding box and center of each rice instance   
%---fill your code here---
radius = 1;
P = imadjust(I);
Q = imbinarize(P);
R = strel('disk', radius);
Q = imopen(Q, R);
s = regionprops(Q,'area','centroid','BoundingBox');
centroids = cat(1,s.Centroid);
BoundingBox = cat(1,s.BoundingBox);
RGB = insertShape(I,'Rectangle',BoundingBox,'Color','green');
figure,
subplot(2,2,1);
imshow(P);
title('RICE Original');
subplot(2,2,2);
imshow(Q);
title('RICE Segmentation');
subplot(2,2,3);
imshow(RGB);
title('RICE Detection');
hold on
plot(centroids(:,1),centroids(:,2),'r*')
area = cat(1,s.Area);
disp('-----Done for MIDTERM Question -----');
%% printing the results, do not modify this part 
fprintf('Total rice number: %d \n', length(area));
fprintf('Mean rice area: %f \n', mean(area));
fprintf('Max rice area: %f \n', max(area));
fprintf('Min rice area: %f \n', min(area));