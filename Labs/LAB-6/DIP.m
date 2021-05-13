classdef DIP
  %%%% This is a class for Digital Image Processing class by Hongkai Yu.
  %%%% This file will be updated.
  %%%% last updated: 03/07/2021
  methods(Static=true)
    %----------------------------------------------------------------------------       
    % Enhance saliency by superpixel oversegmentation: if one superpixel's
    % saliency is higher than 2*mean saliency of the whole image, this
    % superpixel's saliency value is doubled. Otherwise, it is reduced by
    % half value.    
    % sample call: result=DIP.Sp_Enhanced_Saliency('data/0054.jpg', 'data/0054_dcl.png', 500);
    function result = Sp_Enhanced_Saliency(image_path, saliency_path, k)
        im_rgb = imread(image_path);
        saliency = imread(saliency_path);
        [Boundary, Am, Sp, D] = SuperpixelToolBox.SLIC(im_rgb, k, 10, 2, true);
        SpList = SuperpixelToolBox.GetSpList(im_rgb, 1, Boundary, saliency);
        SuperPixelNum=max(Boundary(:));
        PI = regionprops(Boundary,'All'); 
        result = saliency;
        for j=1:SuperPixelNum
            if SpList{j}.Salieny < 2*mean(saliency(:))
                result(PI(j).PixelIdxList)= 0.5*saliency(PI(j).PixelIdxList);
            end
            if SpList{j}.Salieny >= 2*mean(saliency(:))
                result(PI(j).PixelIdxList)= 2*saliency(PI(j).PixelIdxList);
            end
        end
        result = uint8(result);
        figure, subplot(1,3,1), imshow(im_rgb);
        subplot(1,3,2), imshow(saliency);
        subplot(1,3,3), imshow(result);
    end
    %---------------------------------------------------------------------------- 
    % To highlight multiple superpixels on one image 
    % input: % I: color image; L: superpixel segments with id from 1 to k; 
             % sp_id: empty to show all, a list to highlight multiple superpixel  
    % Sample call: 
    % im_rgb = imread('data/0092.jpg');
    % [Boundary, Am, Sp, D] = SuperpixelToolBox.SLIC(im_rgb, 500, 10, 2, true); 
    % out=SuperpixelToolBox.FindNeighbor(Am, 200);  
    % DIP.Highlight_SLIC(im_rgb, Boundary, [200]);  
    % DIP.Highlight_SLIC(im_rgb, Boundary, out);  
    function Highlight_SLIC(I, L, sp_id_list)
        I1=(I(:,:,1));
        I2=(I(:,:,2));
        I3=(I(:,:,3));
        [row,col]=size(I1);
        for i=2:row-1
            for j=2:col-1
                center=L(i,j);
                up=L(i-1,j);
                down=L(i+1,j);
                left=L(i,j-1);
                right=L(i,j+1);
                if center~=up||center~=down||center~=left||center~=right
                    I1(i,j)=0;
                    I2(i,j)=255;
                    I3(i,j)=0;
                end
            end
        end
        
        if ~isempty(sp_id_list)
            for j=1:length(sp_id_list)
                sp_id=sp_id_list(j);
                idx=find(L==sp_id);
                I1(idx)= 255;
                I2(idx)= 0;
                I3(idx)= 0;
            end
        end
        image=cat(3,I1,I2,I3);
        figure, imshow(image);
    end
    %---------------------------------------------------------------------------- 
  end
end