% This CalNormalizedHSV function is to Compute Normalized Color Histogram
%%% input: 
% im: RGB color image
% HbinNum: bin number in H space
% SbinNum: bin number in S space
% VbinNum: bin number in V space

%%% output: 
% Hist: Normalized Color Histogram

% by Hongkai Yu, Nov 9th, 2013
function Hist = CalNormalizedHSV(Im, HbinNum, SbinNum, VbinNum)
Im_HSV=255*rgb2hsv(Im); % result of rgb2hsv is in the range [0,1]
Im_H=Im_HSV(:,:,1);
Im_S=Im_HSV(:,:,2);
Im_V=Im_HSV(:,:,3);
[row,col]=size(Im_H);
gap_H=floor(256/HbinNum);
gap_S=floor(256/SbinNum);
gap_V=floor(256/VbinNum);
Hist=zeros(1,HbinNum*SbinNum*VbinNum);
for i=1:row
    for j=1:col
       H_id=floor(Im_H(i,j)/gap_H+1);
       S_id=floor(Im_S(i,j)/gap_S+1);
       V_id=floor(Im_V(i,j)/gap_V+1);
       ID=(H_id-1)*SbinNum*VbinNum+(S_id-1)*VbinNum+V_id;
       Hist(ID)=Hist(ID)+1;
    end
end
Hist=Hist/(row*col);
 