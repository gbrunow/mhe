function [ output ] = run( file, path, whiter, compare, genHE, genMHE, genFiles )
    
    img = imread([path file]);
    
    try
        img = rgb2gray(img);
    catch e
    end
    
    imgOrig = img;

    cols = 1;
    
    if whiter
        h = imhist(img);
        L = length(h);
        img = L - img;
    end

    if genMHE
        cols = cols + 1;
        imgMHE = mhe(img);
    end

    if genHE
        cols = cols + 1;
        imgHE = he(img);
    end

    splot = 1;
    if compare
        figure;

        subplot(2,cols,splot);
        imshow(imgOrig);
        title('Original');

        subplot(2,cols,splot+cols)
        imhist(imgOrig);

        if genHE
            splot = splot + 1;
            subplot(2,cols,splot);
            map = he(img);
            imgHE = applyMap(img, map);
            if whiter
                imgHE = L - imgHE;
            end
            imshow(imgHE);
            title('HE');

            subplot(2,cols,splot+cols)
            imhist(imgHE);
        end

        if genMHE
            splot = splot + 1;
            subplot(2,cols,splot);
            if whiter
                imgMHE = L - imgMHE;
            end
            imshow(imgMHE);
            title('MHE');

            subplot(2,cols,splot+cols)
            imhist(imgMHE);
        end        

        shg;
    end

    if genFiles && (genHE || genMHE)
        mkdir([path 'out/']);
        fileNameEnd = find(file == '.');
        fileNameEnd = fileNameEnd(end);
        extension = file(fileNameEnd:end);
        fileName = file(1:(fileNameEnd-1));
        if genHE
            imwrite(imgHE, [path 'out/' fileName '_HE' extension]);
        end
        if genMHE
            imwrite(imgMHE, [path 'out/' fileName '_MHE' extension]);
        end
    end
end

