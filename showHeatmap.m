function showHeatmap(t, width, height, commandsHText, lbOpened, imageProps, originalImage)    
    delete(t);
    t = text(width + 50, 200, commandsHText, 'FontWeight', 'bold');
    t.BackgroundColor = 'w';
    t.Color = 'k';
    t.FontSmoothing = 'on';
    t.FontSize = 13;
    t.Margin = 5;

    while(true)
       %User has to select an object
       [xm, ym, button5] = ginput(1);

       if (button5 == 1)
           ret = lbOpened(round(ym),round(xm));
           if (ret ~= 0)
               tX = text(imageProps(ret).Centroid(1)-7, imageProps(ret).Centroid(2)-7, num2str(ret), 'FontWeight', 'bold');
               tX.Color = 'k';
               tX.FontSmoothing = 'on';
               tX.FontSize = 18;

               x1 = imageProps(ret).Centroid(1);
               y1 = imageProps(ret).Centroid(2);
               x2 = 1;

               while x2 <= width
                    y2 = 1;
                    while y2 <= height
                       distance = sqrt((x1-x2).^2 + (y1-y2).^2);
                       matrix(y2,x2) = distance;
                       y2 = y2 + 1;
                    end
                    x2 = x2 + 1;
               end

               a1 = double(originalImage(1,:,:)) + matrix;
               a1n = a1/max(a1(:));
               figure1 = figure('Name', 'first channel figure');
               imagesc(a1n);

               a2 = double(originalImage(:,1,:)) + matrix;
               a2n = a2/max(a2(:));
               figure2 = figure('Name', 'second channel figure');
               imagesc(a2n);

               a3 = double(originalImage(:,:,1)) + matrix;
               a3n = a3/max(a3(:));
               heatmapfigure = figure('Name', 'heatmap figure');
               colormap(heatmapfigure,flipud(jet));
               imagesc(a3n);

               while(true)
                   % Wait for input on graph window
                   [xg, yg, buttonGraph] = ginput(1);

                   if (buttonGraph == 113) % Press q to close graph
                       close(figure1);
                       close(figure2);
                       close(heatmapfigure);
                       break;
                   end
               end
           end
       end
       if (button5 == 114) % Press r to return
           delete(t);
           imshow(originalImage);
           break;
       end
    end
end
    