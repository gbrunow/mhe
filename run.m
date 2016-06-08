function [ output ] = run( file, path, whiter, compare, genHE, genMHE, genFiles )
    
    img = imread([path file]);
    try
        img = rgb2gray(img);
    catch e
    end

    cols = 1;

    if genMHE
        cols = cols + 1;
        imgMHE = mhe(img, whiter);
    end

    if genHE
        cols = cols + 1;
        imgHE = he(img, whiter);
    end

    splot = 1;
    if compare
        figure;

        subplot(2,cols,splot);
        imshow(img);
        title('Original');

        subplot(2,cols,splot+cols)
        imhist(img);

        if genHE
            splot = splot + 1;
            subplot(2,cols,splot);
            map = he(img, whiter);
            imgHE = applyMap(img, map);
            imshow(imgHE);
            title('HE');

            subplot(2,cols,splot+cols)
            imhist(imgHE);
        end

        if genMHE
            splot = splot + 1;
            subplot(2,cols,splot);
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

