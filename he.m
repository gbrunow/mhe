function [ map ] = he(input)

    if isvector(input)
        h = input;
    else
        h = imhist(input);
    end
    if nargin < 2
        whiter = false;
    end    
    
    L = length(h);
    numberOfPixels = sum(h);
    probabilities = h/numberOfPixels;
    sk = cumsum(probabilities);

    map = floor((L-1)*sk);
end