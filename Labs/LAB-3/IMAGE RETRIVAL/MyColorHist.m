function H=MyColorHist(I, r, c, m)
% This function is to compute the color histgram of a color image in the HSV color space(better color representation) 

% I: a 3-channel RGB color image, 
% r and c:  row and col for image resizing
% m=1: method 1, compute the histogram for each channel sperately and then concatenate them
% m=2: method 2, color combination for X bins of each channel
I=imresize(I, [r,c]);
Im_HSV=255*rgb2hsv(I); % result of rgb2hsv is in the range [0,1]

if m==1
    Hh=imhist(Im_HSV(:,:,1));
    Hs=imhist(Im_HSV(:,:,2));
    Hv=imhist(Im_HSV(:,:,3));
    H=[Hh; Hs; Hv];
else
    X=16;                    % HbinNum=SbinNum=VbinNum=X
    HbinNum=X;
    SbinNum=X;
    VbinNum=X;
    Im_H=Im_HSV(:,:,1);
    Im_S=Im_HSV(:,:,2);
    Im_V=Im_HSV(:,:,3);
    [row,col]=size(Im_H);
    gap_H=256/HbinNum;
    gap_S=256/SbinNum;
    gap_V=256/VbinNum;
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
    %H=Hist/(row*col); % uncommon it if you want the normalized histogram  
    H=Hist;  
end

