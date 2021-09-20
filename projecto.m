close all, clear all;

dirPath = pwd;

%Parameters
thr = 120;
minArea = 6;
erosionRadius = 7;
dilationRadius = 3;

originalImg = imread('Moedas/Moedas1.jpg');
grayscaleRed = originalImg(:,:,1);
%figure,imshow(grayscaleRed);

bw1 = grayscaleRed > thr;
%imshow(bw1);

[lb, num] = bwlabel(bw1);
regionProps = regionprops(lb, 'Area', 'Perimeter', 'FilledImage', 'Centroid');
inds = find([regionProps.Area] > minArea);

areas = sort([regionProps.Area]);
perimeters = sort([regionProps.Perimeter]);

%Original coin areas
coin1Cent = areas(:,1);
coin2Cent = areas(:,2);
coin10Cent = areas(:,3);
coin5Cent = areas(:,4);
coin20Cent = areas(:,5);
coin1Eur = areas(:,7);
coin50Cent = areas(:,8);


seEr = strel('disk', erosionRadius);
seOp = strel('disk', dilationRadius);
erosionImage = imerode(bw1, seEr);
openImage = imdilate(erosionImage, seOp);
%imshow(openImage);

[lb2, num2] = bwlabel(openImage);
coinPropsOpened = regionprops(lb2, 'Area', 'Perimeter', 'FilledImage', 'Centroid');

areas2 = sort([coinPropsOpened.Area]);
perimeters2 = sort([coinPropsOpened.Perimeter]);

% Coin areas post-processing
coin1CentP = areas2(:,1);
coin2CentP = areas2(:,2);
coin10CentP = areas2(:,3);
coin5CentP = areas2(:,4);
coin20CentP = areas2(:,5);
coin1EurP = areas2(:,7);
coin50CentP = areas2(:,8);

%Coin area deltas (for calculating amount of money later)
delta1Cent = (coin1Cent - coin1CentP) * dilationRadius / erosionRadius;
delta2Cent = (coin2Cent - coin2CentP) * dilationRadius / erosionRadius;
delta10Cent = (coin10Cent - coin10CentP) * dilationRadius / erosionRadius;
delta5Cent = (coin5Cent - coin5CentP) * dilationRadius / erosionRadius;
delta20Cent = (coin20Cent - coin20CentP) * dilationRadius / erosionRadius;
delta1Eur = (coin1Eur - coin1EurP) * dilationRadius / erosionRadius;
delta50Cent = (coin50Cent - coin50CentP) * dilationRadius / erosionRadius;

nrElements = length(coinPropsOpened);
string1 = sprintf('%s%d','Numero de elementos: ', nrElements);

fprintf('\n......................................................................\n')
fprintf('                         PATTERN RECOGNITION\n')
fprintf('......................................................................\n\n')

fprintf('Choose what you want to do:\n\n')

fprintf('\t1 - Choose image samples from collection\n\n')
fprintf('\t2 - Choose your own image from directory\n\n')
fprintf('\t3 - Exit\n\n\n')

fprintf('Type the number of the command you want:\n\n')
command = input('>> ');

% Actions for each command
switch command
    case 1
        fprintf('\n\n............................................................\n\n')
        
        fprintf('Choose one of the following images to proceeed:\n\n')
        fprintf('\t1 - Moedas1.jpg\n\n')
        fprintf('\t2 - Moedas2.jpg\n\n')
        fprintf('\t3 - Moedas3.jpg\n\n')
        fprintf('\t4 - Moedas4.jpg\n\n\n')
        
        fprintf('Type the number of the image you want:\n\n')
        imgNr = input('>> ');
        
        switch imgNr
            case 1
                imgPath = 'Moedas/Moedas1.jpg';
                originalImage = imread(imgPath);
            case 2
                imgPath = 'Moedas/Moedas2.jpg';
                originalImage = imread(imgPath);
            case 3
                imgPath = 'Moedas/Moedas3.jpg';
                originalImage = imread(imgPath);
            case 4
                imgPath = 'Moedas/Moedas4.jpg';
                originalImage = imread(imgPath);
            otherwise
                fprintf('\nERROR: Invalid image number!\n')
        end
        
    case 2
        fprintf('\n\n......................................................................\n\n')
        
        fprintf('Choose your own image and place it in the current matlab path\n\n')
        fprintf('Current MATLAB path is\n\t>> ')
        fprintf(dirPath)
        
        fprintf('\n\nListing directory contents:\n\n')
        fprintf('\t')
        dir
        fprintf('\n\n......................................................................\n\n')
        
        fprintf('Insert filename of image\n')
        fprintf('OR\n')
        fprintf('type "refresh" to update directory listing\n\n')
        filename = input('>> ', 's');
        
        while strcmp(filename, 'refresh')
            fprintf('\n\nListing directory contents:\n\n')
            fprintf('\t')
            dir
            fprintf('\n\n......................................................................\n\n')
            fprintf('Insert filename of image\n')
            fprintf('OR\n')
            fprintf('type "refresh" to update directory listing\n\n')
            filename = input('>> ', 's');
        end
        
        % Try to open chosen file
        try
            imgPath = strcat(dirPath,'/',filename);
            originalImage = imread(imgPath);
        catch
            fprintf('\nERROR: File not found in directory!\n\n')
        end

    case 3
        return
end

%Start processing image
grayscaleRedOriginal = originalImage(:,:,1);
bw = grayscaleRedOriginal > thr;

eroded = imerode(bw, seEr);
opened = imdilate(eroded, seOp);

[lbOpened, numOp] = bwlabel(opened);
imageProps = regionprops(lbOpened, 'Area', 'Perimeter', 'Centroid', 'BoundingBox', 'FilledImage');
inds = find([imageProps.Area] > minArea);

%Command strings 
commands = {'Press:', 'n - Number of objects', 'm - Object measurements', 'd - Distances between objects',...
'g - Sharpness', 'o - Order by parameter', 'a - Amount of money', 's - Order by similarity',...
't - Transform an object', 'x - Show heatmap', ' ', 'q - Quit'};

commandsText = strjoin(commands, '\n');
commandsN1 = {char(9), char(9), char(9), char(9), char(9), char(9), char(9), char(9), char(9), char(9), char(9), char(9), num2str(length(inds))};
commandsN1Text = strjoin(commandsN1, ' ');
commandsN = {'Number of objects detected: ', ' ', commandsN1Text, ' ', 'Press r to return'};
commandsNText = strjoin(commandsN, '\n');

commandsM = {'Click object to show', 'measurements', ' ', 'Press r to return'};
commandsMText = strjoin(commandsM, '\n');

commandsD = {'Click objects to show', 'distances', ' ', 'Press:', 'r - reset image', 'Press q  to quit'};
commandsDText = strjoin(commandsD, '\n');

commandsG1 = {'Click object', ' ', 'Press q  to quit'};
commandsG1Text = strjoin(commandsG1, '\n');
commandsG2 = {'Choose number of points', 'in the console'};
commandsG2Text = strjoin(commandsG2, '\n');

commandsO = {'Select parameter to order by:', 'a - Area', 'p - Perimeter', 'd - Relative distance', 's - Sharpness',...
    ' ', 'Press q to quit'};
commandsOText = strjoin(commandsO, '\n');
commandsO2 = {'Press: ', 'r - reset', 'q - quit'};
commandsO2Text = strjoin(commandsO2, '\n');
commandsOD = {'Click on object'};
commandsODText = strjoin(commandsOD, '\n');

commandsS1 = {'Select one object', ' ', 'Press r to return'};
commandsS2 = 'Objects most similar to chosen object';

commandsT = {'Click an object', 'to transform and',  'select an option:',  '1 - Rotate right',...
     '2 - Rotate left', '3 - Invert Vertically', '4 - Invert Horizontally', '5 - Scale',' ', 'Press r to return'};
commandsTText = strjoin(commandsT, '\n');

commandsTOption = {'Press q to close figure'};
commandsTOptionText = strjoin(commandsTOption, '\n');

commandsH = {'Click object to show', 'heatmap', ' ', 'Press r to return'};
commandsHText = strjoin(commandsH, '\n');

%Compute and add fields to imageProps
newField = 'Circularity';
for a=1:length(inds)
   imageProps(a).(newField) = (4 * pi * imageProps(a).Area) / ((imageProps(a).Perimeter).^2);
end

newField = 'Sharpness';                   
for a=1:length(inds)
   [Gx, Gy] = gradient(imageProps(a).FilledImage);
   S = sqrt(Gx.*Gx+Gy.*Gy);
   sharpness = sum(sum(S))./(numel(Gx));
   imageProps(a).(newField) = sharpness;
end

%Open selected image
figure('Name','Original Image'), hold on, imshow(originalImage, 'InitialMagnification', 'fit');
[height, width, dim] = size(originalImage);
set(gcf, 'Position', [100 100 1000 500]);

%Program
while(true)
   t = text(width + 50, 200, commandsText, 'FontWeight', 'bold');
   [x, y, button] = ginput(1);
   
   switch button 
       
       case 110 %Letter n - Number of objects
           showNumObject(t, width, commandsNText, originalImage)
           
       case 109 %Letter m - Object measurements
           showMeasurements(t, width, commandsMText, lbOpened, imageProps,...
               inds, opened, originalImage);
           
       case 100 %Letter d - Compute distances
           computeDistances(t, width, commandsD, lbOpened, originalImage, ...
               inds, imageProps);
       
       case 103 %Letter g - Show boundary derivative graph
           showSharpness(t, width, commandsG1, commandsG2Text, lbOpened,...
               opened, originalImage);
           
       case 111 %Letter o - Order objects according to parameter
           orderParameter(t, width, commandsOText, imageProps, originalImage,...
               commandsO2Text, commandsODText, lbOpened, inds, opened, height);
           
       case 116 %Letter t - show transformations
           showTransformations(t, width, height, commandsTText, ...
               originalImage, lbOpened, imageProps, opened, commandsTOptionText);
           
       case 120 %Letter x - show heatmap regions
           showHeatmap(t, width, height, commandsHText, lbOpened, ...
               imageProps, originalImage);
           
       case 97 %Letter a - Amount of money
           amountMoney(t, inds, imageProps, coin1CentP, delta1Cent,...
               coin2CentP, delta2Cent, coin10CentP, delta10Cent, ...
               coin5CentP, delta5Cent, coin20CentP, delta20Cent, coin1EurP, ...
               delta1Eur, coin50CentP, delta50Cent, width, originalImage);
           
       case 115 %Letter s - Show coins according to a similarity measure
           orderSimilarity(t, width, commandsS1, lbOpened, inds, imageProps,...
               originalImage, opened); 
           
       case 113 %Letter q - Quit
           close all;
           break;
           
   end
end
