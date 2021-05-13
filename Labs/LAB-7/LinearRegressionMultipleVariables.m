% Example: linear regression with multiple variables
% Implemented by Hongkai Yu@CSU, 03/21/2021
%%
clear all;
clc;
close all;
%% generate training data [1,x1,x2,x3] of m samples by ground-truth theta=[20, 1, 10, -2]
% f(x) = theta_0 + theta_1*x_1 + theta_2*x_2 +...+ theta_n*x_n
m=100;
x0=ones(m,1);
x=50*rand(m,3)-25;    % in the range of [-25,25]
x=[x0,x]';            % n-by-m matrix: feature #:n, sample #: m
gt=20+x(2,:)+10*x(3,:)-2*x(4,:); % real theta: 20, 1, 10, -2
y=gt;
%% initialize the weights and hyperparameters: 
learning_rate=0.001;
epoch=500;
n=size(x,1);          
theta=zeros(n,1);    % n-by-1 vector
temp=zeros(n,1);
%% Minimize the loss by searching for optimal weights using gradient decent
for i=1:epoch   
    loss(i) = (1/(2*m))*sum(((theta'*x)-y).^2);
    fprintf('epoch: %d, loss:%f \n', i, loss(i));
    % please write your code here for gradient decent based optimization
    
end

theta
%% loss visualization
figure, plot(loss, '-*','LineWidth',2), title('Loss over iterations');
%% apply the trained model 'theta' on test data and compare it with the ground truth 
test=[1,5,13,4]'
gt=20+test(2)+10*test(3)-2*test(4)
predict=theta'*test