function orderSimilarity(t, width, commandsS1, lbOpened, inds, imageProps,...
    originalImage, opened)
    delete(t); 
    clicked = 0;
    while(true)
       if clicked==0
           imshow(originalImage);
       end
       tS1 = text(width + 50, 200, commandsS1, 'FontWeight', 'bold');
       tS1.BackgroundColor = 'w';
       tS1.Color = 'k';
       tS1.FontSmoothing = 'on';
       tS1.FontSize = 13;
       tS1.Margin = 5;

       % Waits for user to select one region
       [xm, ym, buttonS] = ginput(1);

       if (buttonS == 1)
           ret = lbOpened(round(ym),round(xm));
           if (ret ~= 0)
               clicked = 1;
               %Plot object boundaries
                [B, L, N, A] = bwboundaries(opened);

                boundary = B{ret};
                plot(boundary(:,2), boundary(:,1), 'k--', 'LineWidth',3);

               % Using Circularity as a measure
               % Initialise struct to contain similarity values
               listSimilarity = struct('Similarity', {}, 'Index', {});

               for r=1:length(inds)
                   if(r ~= ret)
                       similarity = abs(imageProps(r).Circularity - imageProps(ret).Circularity);

                       % Add similarity and index to struct
                       sim = struct('Similarity', similarity, 'Index', inds(r));
                       listSimilarity = [listSimilarity ; sim];
                   end
               end

               [sorted, ind] = sort([listSimilarity.Similarity]);
               similarityFigure = figure('Name','Similarity between objects');

               hold on;

               for o=1:length(ind)
                   boundingBox = imageProps(listSimilarity(ind(o)).Index).BoundingBox;
                   cropped = imcrop(originalImage, boundingBox);
                   subplot(1, length(ind), o), imshow(cropped);
               end

               while(true)

                   [xm, ym, buttonS2] = ginput(1);

                   if (buttonS2 == 113) % Press q to close figure
                       delete(tS1);
                       close(similarityFigure);
                       clicked = 0;
                       break;
                   end
               end
           end
       end

       if (buttonS == 114) % Press r to return
           delete(tS1);
           imshow(originalImage);
           break;
       end
   end