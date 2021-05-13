function scaledIm = Mapping(Im, limit)
   [row,column] = size(Im);
    Max = max(max(Im));
    Min = min(min(Im));
    scaledIm = Im;
    for p = 1:row 
        for q = 1:column
          scaledIm(p,q)= (((limit(2)-limit(1))/(Max-Min))*(Im(p,q)-Min))+ limit(1);
        end
    end
     if limit(1)<0 || limit(2)>255
        error('Not in range out of limit')
    end
end