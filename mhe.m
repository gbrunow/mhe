[file,path] = uigetfile('*.bmp;*.png','Selecione uma imagem');
img = imread([path file]);
squaredImg1 = img;
squaredImg2 = img;

figure(1);
subplot(2,3,1);
imshow(img);
title('Original');

whiter = false;

subplot(2,3,2);
map = he(img, whiter);
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

maps = zeros(L, length(horizontalCrops)*length(verticalCrops));
newMapNum = zeros(L,1);
newMapDen = zeros(L,1);
levels = 0:(L-1);

k = 1;

for i = 1:(length(horizontalCrops))
    for j = 1:(length(verticalCrops))
        crop = imcrop(img, [horizontalCrops(i),verticalCrops(j), frameWidth-1, frameHeight-1]);
        
        h = imhist(crop);
        occurred = levels(h > 0);
        space = levels(h ~= 0);
        
        bmin = space(1);
        bmax = space(end);
        
        map = he(h, whiter);
        
        if i < length(horizontalCrops)
            y = horizontalCrops(i):(horizontalCrops(i+1)-1);
        else
            y = horizontalCrops(end):width;
        end
        
        if j < length(verticalCrops)
            x = verticalCrops(j):(verticalCrops(j+1)-1);
        else
            x = verticalCrops(end):height;
        end
        
        squaredImg1(x,y) = applyMap(crop,map);        
        
        occurred = map(occurred);
        
        bHmin = min(map);
        bHmax = max(map);
        remapFactor = (bmax - bmin)/(bHmax - bHmin); 
        
        inbound = map >= bmin & map <= bmax;

        map = round((map - bHmin) * remapFactor + bmin);

        squaredImg2(x,y) = applyMap(crop,map);

        newMapNum(inbound) = newMapNum(inbound) + map(inbound);
        newMapDen(inbound) = newMapDen(inbound) + 1;
        
        maps(:,k) = map;
        k = k + 1;
    end
end

figure(1);

newMapDen(newMapDen == 0) = 1;
map = round(newMapNum./newMapDen);

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

figure(2);
subplot(1,2,1)
imshow(squaredImg1);
title('Sem Remapping');

subplot(1,2,2)
imshow(squaredImg2);
title('Com Remapping');

shg;