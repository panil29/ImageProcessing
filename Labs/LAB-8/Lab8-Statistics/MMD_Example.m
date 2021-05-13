% Maximum Mean Discrepancy(MMD) is a distance-measure between two distributions P(X) and Q(Y), 
% which is defined as the squared distance between their embeddings in the RKHS.

% References: 
% https://en.wikipedia.org/wiki/Kernel_embedding_of_distributions
% https://blog.csdn.net/difei1877/article/details/101339927
% https://www.cnblogs.com/kailugaji/p/11004246.html
% 03/2021, copied from Internet, Hongkai Yu
%%
clear all;
clc;
%% sample call for MMD 
S=rand(30,8); %source-domain data distribution/feature  
T=rand(20,8); %target-domain data distribution/feature 
mmd_ST = my_mmd(S, T, 4)
%%
function mmd_XY=my_mmd(X, Y, sigma)
%Author：kailugaji
%Maximum Mean Discrepancy: smaller MMD means more similarity 
%X's and Y's data dimension should be the same, and X, Y does not have labels
%mmd_XY=my_mmd(X, Y, 4)
%sigma is kernel size, Gaussian kernal's sigma
[N_X, ~]=size(X);
[N_Y, ~]=size(Y);
K = rbf_dot(X,X,sigma); %N_X*N_X
L = rbf_dot(Y,Y,sigma);  %N_Y*N_Y
KL = rbf_dot(X,Y,sigma);  %N_X*N_Y
c_K=1/(N_X^2);
c_L=1/(N_Y^2);
c_KL=2/(N_X*N_Y);
mmd_XY=sum(sum(c_K.*K))+sum(sum(c_L.*L))-sum(sum(c_KL.*KL));
mmd_XY=sqrt(mmd_XY);
end
%%
function H=rbf_dot(X,Y,deg)
%Author：kailugaji
%rbf kernal function K(x, y)=exp(-d^2/sigma), d=(x-y)^2, assume that X's and Y's data dimension are the same
%Deg is kernel size, Gaussian kernal's sigma
[N_X,~]=size(X);
[N_Y,~]=size(Y);
G = sum((X.*X),2);
H = sum((Y.*Y),2);
Q = repmat(G,1,N_Y(1));
R = repmat(H',N_X(1),1);
H = Q + R - 2*X*Y';
H=exp(-H/2/deg^2);  %N_X*N_Y
end