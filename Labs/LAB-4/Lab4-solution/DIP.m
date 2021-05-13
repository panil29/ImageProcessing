classdef DIP 
  %%%% This is a class for Digital Image Processing class by Hongkai Yu.
  %%%% This file will be updated.
  %%%% last updated: 02/08/2021
  methods(Static=true)
    %----------------------------------------------------------------------------    
    % spatial filtering for single-channel image with a single-channel mask
    % sample call: 
    %I = imread('boy.png');
    %im=rgb2gray(I);
    %DIP.filter_single(im, (1/16)*[1,2,1;2,4,2;1,2,1]);
    function filteredIm = filter_single(im, mask)
        % check the mask, it should be square
        [row,col]=size(mask);      
        if mod(row,2)==0 || mod(col,2)==0 % mod=0 for even, mod=1 for odd
           disp('Input mask Error: mask dimension should be odd.');
           return;
        end
        % single-channel filtering
        [row_im,col_im, dim]=size(im);
        if dim>1
           disp('Input image Error: image must be single channel.');
           return;
        end
        ExtendIm=zeros(row_im+2*floor(row/2),col_im+2*floor(col/2));    % mask is square, so row==col
        ExtendIm(floor(row/2+1):floor(row_im+row/2),floor(col/2+1):floor(col_im+col/2))=im;
        filteredIm=ExtendIm;
        for r=floor(row/2+1):floor(row_im+row/2)
            for c=floor(col/2+1):floor(col_im+col/2)
                filteredIm(r,c)=sum(sum(ExtendIm(r-floor(row/2):r+floor(row/2),c-floor(col/2):c+floor(col/2)).*mask));
            end
        end
        filteredIm=filteredIm(floor(row/2+1):floor(row_im+row/2),floor(col/2+1):floor(col_im+col/2));
        filteredIm=uint8(filteredIm); % the output should be with data type uint8
        figure, subplot(1,2,1), imshow(im, []), title('Original Image');
        subplot(1,2,2), imshow(filteredIm, []), title('Single-channel Filtered Image');
    end
    %----------------------------------------------------------------------------    
    % spatial filtering for multiple-channel image with a multiple-channel
    % mask, like the convolution in CNN 
    % sample call: 
        % I = imread('boy.png');
        % mask = cat(3, (1/9)*[1,1,1;1,1,1;1,1,1], [1,0,-1;2,0,-2;1,0,-1], [1,2,1;0,0,0;-1,-2,-1]);
        % DIP.filter_multiple(I, mask);
    function filteredIm = filter_multiple(im, mask)
        % check the mask, it should be square
        [row,col]=size(mask);      
        if mod(row,2)==0 || mod(col,2)==0 % mod=0 for even, mod=1 for odd
           disp('Input mask Error: mask dimension should be odd.');
           return;
        end
        % multiple-channel filtering
        [row_im, col_im, dim]=size(im);
        if dim==1
           disp('Input image Error: image must be multiple channel.');
           return;
        end
        filteredIm = zeros(size(im, 1), size(im, 2));
        for i=1:dim
            filteredIm = filteredIm + double(DIP.filter_single(im(:,:,i), mask(:,:,i)));
        end
        filteredIm=uint8(filteredIm);  
        figure, subplot(1,2,1), imshow(im), title('Original Image');
        subplot(1,2,2), imshow(filteredIm), title('Multiple-channel Filtered Image');
    end
    %----------------------------------------------------------------------------    
  end
end