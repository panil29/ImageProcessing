% Example: linear regression with one variable
% Implemented by Hongkai Yu@CSU, 03/21/2021
%%
clear all;
clc;
close all;
%% generate training data [x,y] of m samples
m=100;
x=1:m;
gt=3*x+10;
noise = 10*rand(1,m)-5; % [-5,5]
y= gt + noise;
plot(x, y, 'o');
hold on;
%% initialize the weights and hyperparameters: f(x) = theta0+theta1*x
learning_rate=0.0001;
epoch=50;
theta0=0;
theta1=0;
%% Minimize the loss by searching for optimal weights using gradient decent
for i=1:epoch   
    loss(i) = (1/(2*m))*sum(((theta0+theta1*x)-y).^2);
    fprintf('epoch: %d, loss:%f \n', i, loss(i));
    temp0 = theta0 - learning_rate*(1/m)*sum((theta0+theta1*x)-y); % You can also use different learning rates for theta0 and theta1
    temp1 = theta1 - learning_rate*(1/m)*sum(((theta0+theta1*x)-y).*x);    
    theta0 = temp0;
    theta1 = temp1;   
end
fprintf('Linear regression result-> theta0: %f, theta1:%f \n', theta0, theta1);
plot(x, theta0+theta1*x,'-','LineWidth',3), title('Data and Linear Regression Result');
hold off;
figure, plot(loss, '-*','LineWidth',3), title('Loss over iterations');
