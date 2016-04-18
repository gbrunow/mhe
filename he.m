function [ map ] = he( block, h )
    if(nargin < 2)
        h = imhist(block);
    end
    L = length(h);
    numberOfPixels = sum(h);
    probabilities = h/numberOfPixels;
    sk = cumsum(probabilities);
    map = round((L-1)*sk);
end