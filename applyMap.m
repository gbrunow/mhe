function [ img ] = applyMap( img, map )
    L = length(imhist(img));
    for i = 1:L
        img(img == (i-1)) = map(i);
    end
end

