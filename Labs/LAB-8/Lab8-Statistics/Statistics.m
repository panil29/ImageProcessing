classdef Statistics
  %%%% This is a class for Digital Image Processing class by Hongkai Yu.
  %%%% This file will be updated.
  %%%% last updated: 03/07/2021
  methods(Static=true)
    %----------------------------------------------------------------------------       
    % compute Kullback–Leibler Divergence (sometimes called Relative Entropy) of two distribution  
    % https://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence  
    % Smaller Kullback–Leibler Divergence means more similar distribution 
    % DA.KL_Divergence(P, Q) IS NOT EQUAL TO DA.KL_Divergence(Q, P)
    % sample call:  
        % P=[9/25,12/25,4/25];
        % Q=[1/3,1/3,1/3];
        % result=Statistics.KL_Divergence(P, Q)
    function result = KL_Divergence(P, Q)
        result=sum(P.*log(P./Q));
    end
    %---------------------------------------------------------------------------- 
    % Minimize Entropy means to minimize the uncertainty 
    % maximum uncertainty/Entropy is obtained by equal distribution  
    % Sample call: 
        %P=[0.98,0.01,0.01];
        %resultP=Statistics.Entropy(P)      % 0.1614
        %Q=[1/3,1/3,1/3];
        %resultQ=Statistics.Entropy(Q)      % 1.5850, maximum
    function result = Entropy(P)
        result = -1*sum(P.*log2(P)); 
    end
    %---------------------------------------------------------------------------- 
    % Fit the Multivariate gaussian distribution to sampled data  
    % refer to https://www.mathworks.com/help/stats/multivariate-normal-distribution.html
    % Sample call: 
        %2D features as an example     
        %X = [140, 130; 133, 120; 151, 120; 131, 110; 142, 135; 143, 150];
        %G = Statistics.FitMultivariateGaussian(X) 
    function G = FitMultivariateGaussian(X)
         mu = mean(X);
         CovM = cov(X);
         G.mu=mu;
         G.sigma=CovM;
         %2D feature as an example for visualization, comment the following if for >2D features     
         x1 = 0:0.5:255;
         x2 = 0:0.5:255;
         [X1,X2] = meshgrid(x1,x2);
         X = [X1(:) X2(:)];
         y = mvnpdf(X,mu,CovM); % probability density function (pdf) values of Multivariate Normal Distribution
         
%          %----------implementation for mvnpdf by ourselves, Mahalanobis Distance: distance of each Multivariate observation to a Multivariate Normal Distribution: sum( ((V * inv(CovM)) .* V), 2) 
%          V = X - repmat(mu,[size(X,1),1]);
%          d= size(CovM,1);
%          y_self = (1/sqrt(((2*pi)^d)*det(CovM))) * exp(-(sum( ((V * inv(CovM)) .* V),2) /2));           
%          y=y_self;
%          %----------implementation for mvnpdf by ourselves 
         
         y = reshape(y,length(x2),length(x1));
         figure, surf(x1,x2,y);
         xlabel('x1');
         ylabel('x2');
         zlabel('Probability Density');
    end
    %----------------------------------------------------------------------------
    % Fit the single-variate gaussian distribution to sampled data  
    % Sample call: 
        %X=[140, 130, 141, 133, 120, 125, 151]; % weights/lb
        %G = Statistics.FitGaussian(X) 
    function G = FitGaussian(X)
         mu = mean(X);
         sigma = std(X);
         x = [-300:.1:300];
         y = normpdf(x,mu,sigma); % Normal probability density function
         figure, plot(x,y), title('Probability Density Function');
         G.mu=mu;
         G.sigma=sigma;
    end
    %---------------------------------------------------------------------------- 
    % Maximum A Posteriori (MAP) Estimation for Naive Bayes Classifier: 
    % https://en.wikipedia.org/wiki/Maximum_a_posteriori_estimation
    % https://en.wikipedia.org/wiki/Naive_Bayes_classifier
    % Keys: 1. Prior are the same, 1/2 for the 2-class example; 2. Evidence is shared; 3. Likelihood is the Generative Probability by the learned Gaussian Distribution. 
    % Sample call for single-variate case: 
        %training1=[140, 130, 141, 133, 120, 125, 151];  % training data of class 1: adult weights/lb
        %training2=[40, 30, 41, 33, 20, 25, 51];         % training data of class 2: kid weights/lb
        %G1 = Statistics.FitGaussian(training1);
        %G2 = Statistics.FitGaussian(training2);
        %class = Statistics.BayesMAP(120, G1, G2) % testing for a new data x=120 lb
    % Sample call for Multivariate case:     
        %training1=[140, 180; 133, 170; 161, 180; 131, 178; 123,166]; % training data of class 1: adult weights/lb and heights/cm
        %training2=[40, 70; 13, 72; 15, 62; 31, 61; 54, 83; 64, 90];  %training data of class 2: kid weights/lb and heights/cm
        %G1 = Statistics.FitMultivariateGaussian(training1);
        %G2 = Statistics.FitMultivariateGaussian(training2);
        %class = Statistics.BayesMAP([140, 175], G1, G2) % testing for a new data  
    function class = BayesMAP(x, G1, G2)
        if length(G2.sigma)==1 % single-variate 
            p1 = normpdf(x,G1.mu,G1.sigma);
            p2 = normpdf(x,G2.mu,G2.sigma);
        else % Multivariate
            p1 = mvnpdf(x,G1.mu,G1.sigma);
            p2 = mvnpdf(x,G2.mu,G2.sigma);
        end
        % choose the class with the maximum Posteriori 
        if p1>=p2 
            class=1;
        else
            class=2;
        end
    end
    %---------------------------------------------------------------------------- 
    % learn a GMM (multi-variant gausson) from high-dimentional data  
    % Sample call: 
        % F1=ones(100,5);
        % F2=100*ones(150,5);
        % F3=200*ones(50,5)+5;
        % Features=[F1;F2;F3];
        % GMM = Statistics.LearnGMM(Features, 3) where Features are M-by-N matrix, M: sample number, N: feature dimention   
    function GMM = LearnGMM(Features, NumClusters)
        % Learn GMM parameters
        [BId BCClusters] = kmeans(Features, NumClusters);
        Bdim = size(Features,2);
        BCClusters = zeros(Bdim, NumClusters);
        BWeights = zeros(1,NumClusters);
        BCovs = zeros(Bdim, Bdim, NumClusters);
        for k=1:NumClusters
            relFeatures = Features(find(BId==k),:);        %% belonging to cluster k
            BCClusters(:,k) = mean(relFeatures,1)';
            BCovs(:,:,k) = cov(relFeatures);
            BWeights(1,k) = length(find(BId==k)) / length(BId);
        end
        GMM.BCClusters=BCClusters;
        GMM.BCovs=BCovs;
        GMM.BWeights=BWeights;
    end
    %---------------------------------------------------------------------------- 
    % Learn foreground/object and background GMMs from an 3-channel color image and its saliency map. 
    % Directly use color as multi-variant features 
    % Sample call: 
        %[FgGMM, BgGMM] = Statistics.LearnFgBgGMMs('test.bmp', 'test_saliency.png', 2, 2)  
    function [FgGMM, BgGMM] = LearnFgBgGMMs(image_path, saliency_path, NumFgClusters, NumBgClusters)
        im_org=imread(image_path);
        im_org1 = im_org(:,:,1);
        im_org2 = im_org(:,:,2);
        im_org3 = im_org(:,:,3);
        saliency=imread(saliency_path);
        segIm=im2bw(saliency, 0.3);
        % extract fg/obj pixels and learn a FgGMM for them 
        FgPixel_ID=find(segIm==1);
        FgColors = zeros(length(FgPixel_ID),3);
        FgColors(:,1)=im_org1(FgPixel_ID);
        FgColors(:,2)=im_org2(FgPixel_ID);
        FgColors(:,3)=im_org3(FgPixel_ID);
        FgGMM = Statistics.LearnGMM(FgColors, NumFgClusters); % FgColors: fg feature matrix: *-by-3 
        % extract bkg pixels and learn a BgGMM for them 
        BkgPixel_ID=find(segIm==0);
        BkgColors = zeros(length(BkgPixel_ID),3);
        BkgColors(:,1)=im_org1(BkgPixel_ID);
        BkgColors(:,2)=im_org2(BkgPixel_ID);
        BkgColors(:,3)=im_org3(BkgPixel_ID);
        BgGMM = Statistics.LearnGMM(BkgColors, NumBgClusters);
    end
    %---------------------------------------------------------------------------- 
  end
end