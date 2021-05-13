function h = histogram2(imgname) 

img = imread(imgname); 
figure; 
imshow(img);
[row, col, dim]=size(img);

%%%method2
h=zeros(256,1); 
for L = 0:255
     h(L+1)=sum(sum(img==L));
end
figure; bar(h);
 
