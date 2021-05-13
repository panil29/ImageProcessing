function h = histogram(imgname) 

img = imread(imgname); 
figure; 
imshow(img);
[row, col, dim]=size(img);

%%%method1
h=zeros(256,1); 
for L = 0:255
     for i =1:row 
           for j =1:col
                if img(i,j) == L
                      h(L+1)=h(L+1)+1;
                end
           end    
     end
end
figure; bar(h);
 
