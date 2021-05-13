% This is a class for SVM training and testing, 
% Cleveland Vision & AI Lab
% Cleveland State University, 01/2021
% contact: h.yu19@csuohio.edu
classdef Prior 
  methods(Static=true)
    %---------------------------------------------------------------------------    
    % test trained svm on patch images (gray)
    % load('data/svm/svmStruct_rbf.mat');
    % box_img = imread('data/testing/1.tif');
    % [out, score, ~] = Prior.TestSVM(svmStruct_rbf, box_img)
    function [out, score, hog]=TestSVM(svmStruct_rbf, box_img)
        hog = Prior.hog_single(box_img, 1); % 1: resize to [40,50], 0: no resize, to-do: check the size for other images
        %for old matlab version: predict = ClassificationSVM(svmsvmStruct_rbfStruct_linear, hog);        
        [label, PostProbs] = predict(svmStruct_rbf, hog);
        score = PostProbs(:,1); % positive class posterior probabilities
        if strcmp('fiber', label)
            out=1;
        else 
            out=0;
        end
    end
    %---------------------------------------------------------------------------
    % Prior.TrainSVM('data/sampled_fibers_500.mat', 'data/sampled_bkgs_500.mat');
    function TrainSVM(positive_mat_path, negative_mat_path)
        box_imgs={};
        box_imgs_negative={};
        load(positive_mat_path);                   %box_imgs        
        load(negative_mat_path);          %box_imgs_negative

        positive=[];
        positive_label={};
        parfor i=1:length(box_imgs)
            box_img=box_imgs{i}; 
            hog = Prior.hog_single(box_img, 0);
            positive(i,:)=hog;
            positive_label{i}='fiber';
        end
        disp('positive samples are extracted...');
        
        negative=[];
        negative_label={};
        parfor i=1:length(box_imgs_negative)
            box_img=box_imgs_negative{i};                
            hog = Prior.hog_single(box_img, 0);
            negative(i,:)=hog;
            negative_label{i}='nonfiber';
        end
        disp('negative samples are extracted...');        
        hog=[positive; negative];
        fprintf('hog feature size: %d, %d \n', size(hog,1), size(hog,2));
         
        all_data = hog;
        all_label=[positive_label,negative_label];  
        
        % shuffle all the data
        random_position = randperm(length(all_label));
        all_data=all_data(random_position, :);
        
        tmp=[];
        for k=1:length(all_label)
            tmp{k} = all_label{random_position(k)};
        end
        all_label = tmp;
                
        seed = datasample(1:length(all_label), floor(0.2*length(all_label) ), 'Replace', false ); % testing set seed
        
        id_train=1;
        id_test=1;
        for j = 1: length(all_label) 
             if ismember(j,seed)    % in testing seed
                 test_data(id_test,:) = all_data(j,:);
                 test_label{id_test}= all_label{j};
                 id_test = id_test+1;
             else
                 train_data(id_train,:)  = all_data(j,:);
                 train_label{id_train} = all_label{j};
                 id_train = id_train+1;
             end
        end
 
        svmStruct_linear = fitcsvm(train_data, train_label);
        svmStruct_rbf = fitcsvm(train_data, train_label,'KernelFunction','RBF'); 

        % validation accuracy by linear-kernel svm
        % for old matlab version: predict = ClassificationSVM(svmStruct_linear,test_data);
        CompactSVMModel = compact(svmStruct_linear);
        svmStruct_linear = fitPosterior(CompactSVMModel, train_data, train_label);        
        [label1, PostProbs1] = predict(svmStruct_linear,test_data);
        score1=PostProbs1(:,1); % positive class posterior probabilities
        
        correct=0;
        for i=1:length(label1)
            if strcmp(test_label{i},label1{i})
                correct=correct+1;
            end
        end
        fprintf('validation accuracy for svm linear is %f \n', correct/length(label1));
        
        % validation accuracy by rbf-kernel svm
        % for old matlab version: predict = ClassificationSVM(svmStruct_rbf,test_data);
        CompactSVMModel2 = compact(svmStruct_rbf);
        svmStruct_rbf = fitPosterior(CompactSVMModel2, train_data, train_label);
        [label2, PostProbs2] = predict(svmStruct_rbf,test_data);
        score2=PostProbs2(:,1); % positive class posterior probabilities
       
        correct=0;
        for i=1:length(label2)
            if strcmp(test_label{i},label2{i})
                correct=correct+1;
            end
        end
        fprintf('validation accuracy for svm rbf is %f \n', correct/length(label2));
        
        save(['data/svm/svmStruct_rbf.mat'], 'svmStruct_rbf');
        save(['data/svm/svmStruct_linear.mat'], 'svmStruct_linear');
    end
    %---------------------------------------------------------------------------   
    function hog = hog_single(box_img, do_resize)
        if do_resize==1
           size=[40,50];  % to-do: change a reasonable size for other tasks
           Im_gray = imresize(box_img, size); 
        else
           Im_gray = box_img;    
        end        
        [hog,hog_visualization] = extractHOGFeatures(Im_gray,'CellSize',[15,15]);         
    end
    %---------------------------------------------------------------------------
    function out = hog_distance(im1, im2, size)
       if nargin==2
           size=[50,50]; % to-do: change a reasonable size for other tasks
       end
       Im1_gray=imresize(im1, size);
       Im2_gray=imresize(im2, size);
       [hog1,~] = extractHOGFeatures(Im1_gray,'CellSize',[5 5]);
       [hog2,~] = extractHOGFeatures(Im2_gray,'CellSize',[5 5]);
       feature1=[hog1];
       feature2=[hog2];
       out.l1distance=sum(abs(feature1-feature2));
       out.l2distance=sqrt(sum((feature1-feature2).^2));
    end
    %---------------------------------------------------------------------------
  end
end
