img = imread('Cameraman256.png');
% img = imread('imagemClara.bmp');
% img = rgb2gray(img);

subplot(2,3,1);
imshow(img);
title('Original');

subplot(2,3,2);
map = he(img);
img2 = applyMap(img, map);
imshow(img2);
title('HE');

frameHeight = 32;
frameWidth = 32;

[height, width] = size(img);
horizontalCrops = 1:frameWidth:width;
verticalCrops = 1:frameHeight:height;

initialHistogram = imhist(img);
L = length(initialHistogram);

crops = cell(length(horizontalCrops), length(verticalCrops));
maps = zeros(L, length(horizontalCrops)*length(verticalCrops));
newMapDen = zeros(L,1);
newMapNum = zeros(L,1);
% boundaries = zeros(L,2);
k = 1;
for i = 1:(length(horizontalCrops))
    for j = 1:(length(verticalCrops))
        crop = imcrop(img, [horizontalCrops(i),verticalCrops(j), frameWidth-1, frameHeight-1]);
        
        h = imhist(crop);        
        bmin = min(h);
        bmax = max(h);
%         boundaries(i,:) = [bmin, bmax];
        
        map = he(crop,h);
%         map = h;
        
        bHmin = min(map);
        bHmax = max(map);
        remapFactor = (bmax - bmin)/(bHmax - bHmin);   
        map = (map - bHmin) * remapFactor + bmin;
        
        inbound = map >= bmin & map <= bmax;
%         map(~inbound) = 0;
        newMapDen(inbound) = newMapDen(inbound) + map(inbound);
        newMapNum(inbound) = newMapNum(inbound) + 1;
        
        maps(:,k) = map;
        crops{i,j} = crop;
        k = k + 1;
    end
end

newMapNum(newMapNum == 0) = 1;
map = round(newMapDen./newMapNum);
% map(isnan(map)) = 0;
img3 = applyMap(img,map);

    
subplot(2,3,3);
imshow(img3);
title('MHE');

subplot(2,3,4)
imhist(img);

subplot(2,3,5)
imhist(img2);

subplot(2,3,6)
imhist(img3);
% hold on;

% for i = 1:length(horizontalCrops)
%     for j = 1:length(verticalCrops)
%         plot(horizontalCrops(i),verticalCrops(j), 'g.');
%     end
% end

% hold off;

shg;