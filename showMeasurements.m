function showMeasurements(t, width, commandsMText, lbOpened, imageProps,...
    inds, opened, originalImage)
    delete(t);
    t = text(width + 50, 200, commandsMText, 'FontWeight', 'bold');
    t.BackgroundColor = 'w';
    t.Color = 'k';
    t.FontSmoothing = 'on';
    t.FontSize = 13;
    t.Margin = 5;

    %Flag to know if there are text boxes to erase
    openTBox = 0;

    while(true)
       %User has to select an object
       [xm, ym, button5] = ginput(1);

       if (button5 == 1)
           ret = lbOpened(round(ym),round(xm));
           if (ret ~= 0)
               xr = imageProps(inds(ret)).Centroid(1);
               yr = imageProps(inds(ret)).Centroid(2);
                            
               %Object measurement information
               objectIdText = strjoin({'Object ', num2str(ret)});
               areaText = strjoin({'Area:', num2str(imageProps(ret).Area)}); 
               perimeterText = strjoin({'Perimeter:', num2str(imageProps(ret).Perimeter)});
               legendText = strjoin({objectIdText, areaText, perimeterText}, '\n');
               
               %Plot centroid
               plot(imageProps(inds(ret)).Centroid(1),imageProps(inds(ret)).Centroid(2),'r.', 'MarkerSize',20)
               %Plot object boundaries
               [B, L, N, A] = bwboundaries(opened);

               boundary = B{ret};
               plot(boundary(:,2), boundary(:,1), 'k--', 'LineWidth',3);
               
               %If object has a hole
               if nnz(A(:,ret)) > 0
                    %Loop through the children of boundary ret
                    for l = find(A(:,ret))'
                       boundary = B{l};
                       plot(boundary(:,2), boundary(:,1), 'w--', 'LineWidth', 3);
                   end
               end     
               
               a3 = double(originalImage(:,:,1));
               a3n = a3/max(a3(:));
               areasfigure = figure('Name', 'areas figure');
               colormap(areasfigure,jet);
               imagesc(a3n);
               
               %Position textbox
               tBox = text(xr-80-imageProps(ret).Perimeter/(2*pi), yr-imageProps(ret).Perimeter/(2*pi)-50, legendText, 'FontWeight', 'bold');
               tBox.BackgroundColor = 'w';
               tBox.Color = 'k';
               tBox.FontSmoothing = 'on';
               tBox.FontSize = 10;
               tBox.Margin = 5;
               %Signal that there are text boxes to erase
               openTBox = 1;
               
               while(true)
                   % Wait for input on graph window
                   [xg, yg, buttonGraph] = ginput(1);

                   if (buttonGraph == 113) % Press q to close graph
                       close(areasfigure);
                       imshow(originalImage);
                       break;
                   end
               end
           end
       end
       if (button5 == 114) %Pressing r to return
           if(openTBox == 1)
               delete(tBox)
           end
           delete(t);
           imshow(originalImage);
           break;
       end
    end
end