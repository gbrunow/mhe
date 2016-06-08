function [ map ] = he(input, whiter)

    if isvector(input)
        h = input;
    else
        h = imhist(input);
    end
    if nargin < 2
        whiter = false;
    end
    
    if whiter
        direction = 'reverse';
    else
        direction = 'forward';
    end
    
    
    L = length(h);
    numberOfPixels = sum(h);
    probabilities = h/numberOfPixels;
    sk = cumsum(probabilities, direction);

    map = floor((L-1)*sk);
end