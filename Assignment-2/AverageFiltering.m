
function filteredIm = AverageFiltering(Im, mask)
    [row, Column] = size(mask);
    if row ~= Column
        error('Error occured: Mask is not square matrix');
     mod(Column,2) == 0
        error('Error occured: Size of mask is even');
    end
filteredIm = Im;
for p = 1 : size(Im,1)-Column+1
        for q = 1 : size(Im,2)-Column+1
            window = Im(p:p+Column-1, q:q+Column-1);
            filteredIm(p,q) = sum(sum(double(window) .* mask));
        end
end
end