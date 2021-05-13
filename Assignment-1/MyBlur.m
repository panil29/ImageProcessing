function BI = MyBlur(I)
    k=4;
    P2 = double(I);
    [x,y] = size(I);%x is for rows and y is for columns
    BI = zeros(x,y); 
    for i = 1:x
        for j = 1:y
           topRow = i-k;
            bottomRow = i+k;
            leftCol = j-k;
            RightCol = j+k;
            if topRow < 1
                topRow = 1;
            end
            if bottomRow > x
                bottomRow = x;
            end
            if leftCol < 1
                leftCol = 1;
            end
            if RightCol > y
                RightCol = y;
            end
            a = P2(topRow:bottomRow, leftCol:RightCol);
            BI(i,j) = mean(mean(a));
        end
    end
     BI = uint8(BI);
     [x1,y1,dim]=size(I);
     if dim == 3 % check if it is rgb or grayscale
         C = y/3;
         I_r=BI(1:x1,1:C);
         I_g=BI(1:x1,C+1:2*C);
         I_b=BI(1:x1,(2*C)+1:3*C);
         BI=cat(3,I_r,I_g,I_b);
     end     
 end