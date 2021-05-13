classdef DIP
  %%%% This is a class for Digital Image Processing class by Hongkai Yu.
  %%%% This file will be updated.
  %%%% last updated: 02/28/2021
  methods(Static=true)
    %----------------------------------------------------------------------------    
    % For a binary image, find connected components, ignore small ones (area < an input threshold), 
    % then draw blue star for each center, then draw a large red circle for the center of the largest connected component.
    % sample call: DIP.LabelObjects('demo.tif', 50);
    function LabelObjects(mask_path, th)
        m = imread(mask_path);
        CC = bwconncomp(m);
        numPixels = cellfun(@numel, CC.PixelIdxList);
        keep_id=find(numPixels > th);
        [biggest, idx] = max(numPixels);        
        s = regionprops(m,'centroid');
        centroids= cat(1, s.Centroid);
        x_largest = centroids(idx,1);
        y_largest = centroids(idx,2);
        centroids = centroids(keep_id,:);        
        figure, subplot(1,2,1), imshow(m);
        subplot(1,2,2), imshow(m);
        hold on;
        plot(centroids(:,1), centroids(:,2), 'b*');
        plot(x_largest, y_largest, 'ro', 'MarkerSize', 20);
        hold off;        
    end
    %----------------------------------------------------------------------------    
    % For a binary image, find connected components, remove small ones (area < an input threshold). 
    % sample call: DIP.RemoveSmall('demo.tif', 50);
    function result = RemoveSmall(mask_path, th)
        m = imread(mask_path);
        CC = bwconncomp(m);
        numPixels = cellfun(@numel, CC.PixelIdxList);
        remove_id=find(numPixels <= th);
        result = m;
        for i=1:length(remove_id)
            result(CC.PixelIdxList{remove_id(i)})=0;
        end
        figure, subplot(1,2,1), imshow(m);
        subplot(1,2,2), imshow(result);
    end
    %---------------------------------------------------------------------------- 
    % For a binary image, find connected components, ignore small ones (area < an input threshold), 
    % then draw a tight bounding box for each connected component. 
    % sample call: DIP.LabelObjectsBBX('demo.tif', 50);
    function LabelObjectsBBX(mask_path, th)
        original = imread(mask_path);
        m = DIP.RemoveSmall(mask_path, th);       
        s = regionprops(m,'BoundingBox');
        bbx= cat(1, s.BoundingBox);
        figure, subplot(1,2,1), imshow(original);
        subplot(1,2,2), imshow(original);
        hold on;
        for i=1:size(bbx,1)
            rectangle('Position', bbx(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
        end
        hold off;        
    end
    %---------------------------------------------------------------------------- 
  end
end