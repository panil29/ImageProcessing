classdef DIP
  %%%% This is a class for Digital Image Processing class by Hongkai Yu.
  %%%% This file will be updated.
  %%%% last updated: 02/06/2019
  methods(Static=true)
    %--------------------------------------------------------------------------- 
    % convert all the images in a path from in_format to out_format;
    % delete_orig==1 means to delete original images of in_format
    % sample call: DIP.ConvertImgs('data/V0/', 'tif', 'jpg', 1);
    function []= ConvertImgs(path, in_format, out_format, delete_orig)
        JPGFile=dir([path '*.' in_format]); 
        ImageNum=size(JPGFile,1);
        for i=1:ImageNum
            I=imread([path JPGFile(i).name]);
            [pathstr,name,ext] =fileparts(JPGFile(i).name);
            if delete_orig==1
                delete([path JPGFile(i).name]);
            end           
            imwrite(I,[path name, '.' out_format]);
        end
    end
    %----------------------------------------------------------------------------
    %sample call: DIP.ParseVideo2Images(['video_data/V0.avi'], ['data/V0/'], 1);
    function [] = ParseVideo2Images(video_path, output_images_path, frame_start_save)
        mov = VideoReader(video_path);    
        for i=1:mov.NumberOfFrames
            fprintf('%d/%d\n', i, mov.NumberOfFrames);
            if i<frame_start_save
                continue;
            end
            img = read(mov,i);
            filename = [sprintf('%06d',i-1) '.tif'];
            fullname = fullfile(output_images_path,filename);
            imwrite(img,fullname);    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.) 
        end
    end
    %----------------------------------------------------------------------------
    %compute background image simply by averaging
    %sample call: DIP.ComputeBkg(['data/V0/'], 'tif', 'data/V0_bkg.tif');
    function ComputeBkg(in_path, in_format, outpath)
        JPGFile=dir([in_path '*.' in_format]); 
        ImageNum=size(JPGFile,1);
        % write your code here
        for i=1:ImageNum
            I=imread([in_path JPGFile(i).name]);
            % write your code here
        end
        % write your code here
        imwrite(bkg,outpath);
    end
    %----------------------------------------------------------------------------
    %Background subtraction
    %sample call: DIP.BkgSub('data/V0/', 'tif', 'data/V0_bkg.tif', 'output/V0/');
    function BkgSub(in_path, in_format, bkg_path, outpath)
        % write your code here
    end
    %----------------------------------------------------------------------------
  end
end