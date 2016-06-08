function [ outimg ] = applyMap( img, map )
    L = length(imhist(img));
    outimg = img;
    for i = 1:L
        outimg(img == (i-1)) = map(i);
    end
end

