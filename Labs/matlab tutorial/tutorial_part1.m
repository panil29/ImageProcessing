%%%%% This is a Matlab tutorial by Hongkai Yu, 01/14/2021
%%%%% Department of EE&CS, Cleveland State University
%%%%% h.yu19@csuohio.edu
%%%%% ---------------------------------------------------------------------
%%%%% part 1: basic matrix and vector computation, if else, loop, slice, function call, plot   
%% 
clear all;      % clear all the current variables
close all;      % close all the opened figures 
clc;            % clear the command windows
%% matrix computation
A=[1 2 3;4 5 6;7 8 9];  % It shows the variable in command windows if without ';' 
A1 = A(:) 
A2 = A(:)'              % transpose a matrix or vector
[row,col,dim]=size(A)   % check dimention of the matrix or vector
size(A1)
size(A2)
temp1=A1*A2
temp2=A2*A1
temp3=max(A(:))
temp4=max(A1)
B=A+1;
B
C=A.*2;         % elementwise multiply
C
D=5*ones(3);    % D is a 3-by-3 matrix whose each element is 5
E=A+D;
E
F1=sum(E(:))
F2=sum(E)
%% if else, for loop as example. While loop as practice. 
sum_v=0;
max_v=1;
for i=1:100
    sum_v = sum_v+i;
    if i > max_v
        max_v=i;
    else
        % do what you want
    end       
end
fprintf('sum is %d \n', sum_v);     % the '%d' is for int, '%f' is for float, '\n' is changing to another line 
fprintf('max is %f \n', max_v);
%% slice
K=1:100;
sum(K)
max(K)
H= [11,4,4,5,78,2,355,1156,77,133,898,13,56,11,4468,135457,67,78,88,11]; 
H(1)    % id starts from 1
H(3:10)
max(H(3:10))
H(5)
H(5)=100000;
H
H(10:end)
%% call functions
out = computation(10,20);
a = out.add
b = out.sub

out = computation(1:10,11:20); 
a = out.add
b = out.sub
%% plot figures: y1 = sin(x) and y2 = cos(x)+2
x = -10:0.1:10;             % -10 to 10 with the step 0.1
y1 = sin(x);
figure, plot(x,y1,'-ro');   % red circle
hold on;
y2 = cos(x)+2;
plot(x,y2,'-b*');           % blue star
hold off;
xlabel('x'), ylabel('y'),title('y=f(x)'),grid on, legend('y1=sin(x)', 'y2=cos(x)+2');