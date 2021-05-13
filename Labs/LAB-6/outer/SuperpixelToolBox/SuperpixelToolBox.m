classdef SuperpixelToolBox
    % Hongkai Yu @ University of South Carolina, Columbia, SC. 04/29/2018
  methods(Static=true)
    %---------------------------------------------------------------------------
    % Sample call: [L, Am, Sp, D] = SuperpixelToolBox.SLIC(im_rgb, 200, 10, 2, true);
    % input and output refer to slic.m
    function [L, Am, Sp, D] = SLIC(im_rgb, k, m, seRadius, viz_flag)
        tic;
        [L, Am, Sp, D] = slic(im_rgb, k, m, seRadius); % L: superpixel id: 1 to k  
        toc;
        if viz_flag==true
            SuperpixelToolBox.ShowSLIC(im_rgb, L, []);
        end
    end
    %---------------------------------------------------------------------------
    % input: % I: color image; L: superpixel segments with id from 1 to k; 
             % sp_id: empty to show all, a number to highlight one superpixel  
    % Sample call: SuperpixelToolBox.ShowSLIC(im_rgb, L, 10); or SuperpixelToolBox.ShowSLIC(im_rgb, L, []); 
    function ShowSLIC(I, L, sp_id)
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
        if ~isempty(sp_id)
            idx=find(L==sp_id);
            I1(idx)= 255;
            I2(idx)= 0;
            I3(idx)= 0;
        end
        image=cat(3,I1,I2,I3);
        figure, imshow(image);
        
    end
    %---------------------------------------------------------------------------
    % Find the neighbor superpixel for one single superpixel
    % input: 
        %Am: Adjacency matrix of segments by slic.m; Am(i, j) indicates whether segments labeled i and j are connected/adjacent
        %sp_id: superpixel id that want to search for      
    % Sample call: out = SuperpixelToolBox.FindNeighbor(Am, 10);
    function out=FindNeighbor(Am, sp_id)
        if sp_id<=size(Am,1)
            out=find(Am(sp_id,:)==1);
        else
            out=[];
        end
    end
    %---------------------------------------------------------------------------
    % Get a Superpixel List contains all the superpixel information in a single image
    % input: im_rgb: original RGB image; ImgID: image id in a group; Boundary: oversegmentation boundary, e.g., SLIC superpixels; 
    % output: SpList: A new data structure with samples for all superpixl in a list:
        % Sp.ImgID=2;
        % Sp.SpID=10; % superpixel id in single image
        % Sp.RGBColor=[110 110 100];  
        % Sp.LABColor=[220 220 220];  
        % Sp.Texture %6D texture feature, refer to statxture.m
        % Sp.Salieny=0.5;
        % Sp.Area=880;
        % Sp.Center=[50,200];%row and col position of the center
        % Sp.Label=0; %label of the superpixel (like Seg label or cluster id), which is initialized to be 0
    % Sample call: SpList = SuperpixelToolBox.GetSpList(im_rgb, 1, Boundary, Saliency_Map);
    function SpList=GetSpList(im_rgb,ImgID,Boundary,Saliency_Map)
        im_R=im_rgb(:,:,1);
        im_G=im_rgb(:,:,2);
        im_B=im_rgb(:,:,3);
        im_gray=rgb2gray(im_rgb);
        colorTransform = makecform('srgb2lab');% rgb 2 lab
        im_lab = applycform(im_rgb, colorTransform); % rgb 2 lab color space
        im_l=im_lab(:,:,1);
        im_a=im_lab(:,:,2);
        im_b=im_lab(:,:,3);
        SuperPixelNum=max(Boundary(:));
        PI = regionprops(Boundary,'All');   
        SpList=cell(SuperPixelNum,1);
        Sp.ImgID=ImgID;
        Sp.Label=0;
        Textures= [];
        for j=1:SuperPixelNum
               Sp_id=j;
               t=statxture(im_gray(PI(Sp_id).PixelIdxList)); % 6D texture feature, refer to statxture.m
               Textures(j,:)=t;
        end
        for j=1:SuperPixelNum
               Sp_id=j;
               Sp.SpID =Sp_id;
               Sp.RGBColor = [mean(im_R(PI(Sp_id).PixelIdxList)),mean(im_G(PI(Sp_id).PixelIdxList)),mean(im_B(PI(Sp_id).PixelIdxList))];
               Sp.LABColor=[mean(im_l(PI(Sp_id).PixelIdxList)),mean(im_a(PI(Sp_id).PixelIdxList)),mean(im_b(PI(Sp_id).PixelIdxList))];
               Sp.Texture=Textures(j,:);%Average gray level, Average contrast, Entropy  
               Sp.Salieny= mean(Saliency_Map(PI(Sp_id).PixelIdxList));   % SP mean saliency 
               Sp.Area=length(Saliency_Map(PI(Sp_id).PixelIdxList)); % SP area 
               Cent= PI(Sp_id).Centroid;
               Sp.Center=[int32(Cent(2)), int32(Cent(1))];
               SpList{j}=Sp;
        end
    end
    %---------------------------------------------------------------------------
  end
end
