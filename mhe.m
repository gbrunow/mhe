function [ imgMHE ] = mhe( img, frameHeight, frameWidth )
    if nargin < 4
        frameHeight = 32;
        frameWidth = 32;
    end

    [height, width] = size(img);
    horizontalCrops = 1:frameWidth:width;
    verticalCrops = 1:frameHeight:height;

    initialHistogram = imhist(img);
    L = length(initialHistogram);

    maps = zeros(L, length(horizontalCrops)*length(verticalCrops));
    newMapNum = zeros(L,1);
    newMapDen = zeros(L,1);
    levels = 0:(L-1);

    k = 1;

    for i = 1:(length(horizontalCrops))
        for j = 1:(length(verticalCrops))
            crop = imcrop(img, [horizontalCrops(i),verticalCrops(j), frameWidth-1, frameHeight-1]);

            h = imhist(crop);
            space = levels(h ~= 0);

            bmin = space(1);
            bmax = space(end);

            map = he(h);

            inbound = map >= bmin & map <= bmax;     

            bHmin = min(map);
            bHmax = max(map);

            remapFactor = (bmax - bmin)/(bHmax - bHmin); 

            map = round((map - bHmin) * remapFactor + bmin);

            newMapNum(inbound) = newMapNum(inbound) + map(inbound);
            newMapDen(inbound) = newMapDen(inbound) + 1;

            maps(:,k) = map;
            k = k + 1;
        end
    end

    newMapDen(newMapDen == 0) = 1;
    map = round(newMapNum./newMapDen);

    imgMHE = applyMap(img,map);
end

