

%==========================================================================
data_folder1 = '../video/data/c01/';
data_folder2 = '../video/data/c02/';

files1 = dir([data_folder1, '*.jpg']);
files2 = dir([data_folder2, '*.jpg']);

if numel(files1) ~= numel(files2)
    error('Number of images in two folders are not the same');
end

out_folder1 = '../video/motion_corrected/c01/';
out_folder2 = '../video/motion_corrected/c02/';
if ~exist(out_folder1, 'dir')
    mkdir(out_folder1);
end
if ~exist(out_folder2, 'dir')
    mkdir(out_folder2);
end

%==========================================================================
% include optical flow path, configure parameters for OF computation
addpath(genpath('../Tools/OpticalFlow/'));
alpha = 0.012;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];


%==========================================================================
cnt = 1;
FlowMat_a = cell(numel(files1)-1, 1);
FlowMat_b = cell(numel(files2)-1, 1);
for i=1:numel(files1)-1
    
    fprintf([sprintf('%05d/%05d', i, numel(files1)), '\n']);
    
    % camera 1
    if i>1
        im1_a = im2_a;
    else
        im1_a = im2double(imread([data_folder1, files1(i).name]));
    end
    im2_a = im2double(imread([data_folder1, files1(i+1).name]));
    
    % compute OF for camera 1 and write to image
    if ~exist([out_folder1, files1(i).name], 'file')
        [vx_a,vy_a,warpI2_a] = Coarse2FineTwoFrames(im1_a,im2_a,para);
        vx_a = vx_a - mean(vx_a(:));
        vy_a = vy_a - mean(vy_a(:));
        flow_a(:,:,1) = vx_a;
        flow_a(:,:,2) = vy_a;
        FlowMat_a{cnt} = flow_a;
        imflow_a = flowToColor(flow_a);
        imwrite(imflow_a, [out_folder1, files1(i).name], 'jpg');
    end
    
    % camera 2
    if i>1
        im1_b = im2_b;
    else
        im1_b = im2double(imread([data_folder2, files2(i).name]));
    end
    im2_b = im2double(imread([data_folder2, files2(i+1).name]));
    
    % compute OF for camera 2 and write to image
    if ~exist([out_folder2, files2(i).name], 'file')
        [vx_b,vy_b,warpI2_b] = Coarse2FineTwoFrames(im1_b,im2_b,para);
        vx_b = vx_b - mean(vx_b(:));
        vy_b = vy_b - mean(vy_b(:));
        flow_b(:,:,1) = vx_b;
        flow_b(:,:,2) = vy_b;
        FlowMat_b{cnt} = flow_b;
        imflow_b = flowToColor(flow_b);
        imwrite(imflow_b, [out_folder2, files2(i).name], 'jpg');
    end
    
    clear flow_a flow_b;
    cnt = cnt+1;
end