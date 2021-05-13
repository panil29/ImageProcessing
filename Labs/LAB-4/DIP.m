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
        % write your code here 
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
        [row_im, col_im, dim]=size(im);
        if dim==1
           disp('Input image Error: image must be multiple channel.');
           return;
        end
        filteredIm = zeros(size(im, 1), size(im, 2));
		% multiple-channel filtering by calling DIP.filter_single() accordingly 
        % write your code here
        figure, subplot(1,2,1), imshow(im), title('Original Image');
        subplot(1,2,2), imshow(filteredIm), title('Multiple-channel Filtered Image');
    end
    %----------------------------------------------------------------------------    
  end
end