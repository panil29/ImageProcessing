function filteredIm = MedianFiltering(Im, mask)
    [row,column] = size(mask);
    if row ~= column
        error('Error occured: Mask is not square matrix');
     mod(column,2)==0
        error('Error occured: Size of mask is even');
    end
filteredIm = Im;
for p = 1 : size(Im,1)-column+1
        for q = 1 : size(Im,2)-column+1
            window = Im(p:p+column-1, q:q+column-1);
            filteredIm(p,q) = median(median(double(window) .* mask));
        end
end
end