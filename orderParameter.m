function orderParameter(t, width, commandsOText, imageProps, originalImage,...
    commandsO2Text, commandsODText, lbOpened, inds, opened, height)   
   delete(t);
   t = text(width + 50, 200, commandsOText, 'FontWeight', 'bold');
   t.BackgroundColor = 'w';
   t.Color = 'k';
   t.FontSmoothing = 'on';
   t.FontSize = 13;
   t.Margin = 5;

   %Flag to know if there is another image to close
   openImg = 0;

   while(true)
       [~, ~, button4] = ginput(1);

       if(button4 == 97) %Press a - Order by area
           regionAreas = [imageProps.Area];
           %Sort in ascending order
           [~, ind] = sort(regionAreas);
           orderedFigure = figure('Name','Objects ordered by Area', 'Position', [10 10 1200 800]);
           aux = [];
           for o=1:length(ind)
               boundingBox = imageProps(ind(o)).BoundingBox;
               cropped = imcrop(originalImage, boundingBox);
               if (o~=1)
                   imgResized = imresize(cropped, (1 + (o * 0.06)));
                   aux(o) = subplot(1, length(ind), o); imshow(imgResized);
               end
               if (o==1)
                   imgResized = imresize(cropped, o);
                   aux(o) = subplot(1, length(ind), o); imshow(imgResized);
               end
           end
           %Alligning all images according to x axis
           linkaxes(aux, 'x');

           t2 = text(width + 50, 200, commandsO2Text, 'FontWeight', 'bold');
           t2.BackgroundColor = 'w';
           t2.Color = 'k';
           t2.FontSmoothing = 'on';
           t2.FontSize = 13;
           t2.Margin = 5;
           openImg = 1;
           while(true)
               [xm, ym, button5] = ginput(1);
               if (button5 == 113) %Pressing q to quit
                   if(openImg == 1)
                       close(orderedFigure);
                       openImg = 0;
                   end
                   delete(t);
                   imshow(originalImage);
                   t = text(width + 50, 200, commandsOText, 'FontWeight', 'bold');
                   t.BackgroundColor = 'w';
                   t.Color = 'k';
                   t.FontSmoothing = 'on';
                   t.FontSize = 13;
                   t.Margin = 5;
                   break;
               end
           end
       end

       if(button4 == 112) %Press p - Order by perimeter
           regionPerimeters = [imageProps.Perimeter];
           [~, ind] = sort(regionPerimeters);
           orderedFigure = figure('Name','Objects ordered by Perimeter', 'Position', [10 10 1200 800]);
           hold on;

           for o=1:length(ind)
               boundingBox = imageProps(ind(o)).BoundingBox;
               cropped = imcrop(originalImage, boundingBox);
               if (o~=1)
                   imgResized = imresize(cropped, (1 + (o * 0.06)));
                   ax(o) = subplot(1, length(ind), o); imshow(imgResized);
               end
               if (o==1)
                   imgResized = imresize(cropped, o);
                   ax(o) = subplot(1, length(ind), o); imshow(imgResized);
               end
           end
           linkaxes(ax, 'x');
           openImg = 1;
           while(true)
               [xm, ym, button5] = ginput(1);
               if (button5 == 113) %Pressing q to quit
                   if(openImg == 1)
                       close(orderedFigure);
                       openImg = 0;
                   end
                   delete(t);
                   imshow(originalImage);
                   t = text(width + 50, 200, commandsOText, 'FontWeight', 'bold');
                   t.BackgroundColor = 'w';
                   t.Color = 'k';
                   t.FontSmoothing = 'on';
                   t.FontSize = 13;
                   t.Margin = 5;
                   break;
               end
           end
       end

       if(button4 == 115) %Press s - Order by sharpness
           [B,~,N] = bwboundaries(opened);
           nrPoints = 30;
           sharpnesses = [];

           if (length(B) ~= N)
               B(end) = [];
           end

           for a=1:length(B)
               boundary = [];
               step = floor(length(B{a})/nrPoints);
               index = 1;

               for l=1:nrPoints
                   if((B{a}(index,2) ~= 1) && (B{a}(index,1) ~=1) && (B{a}(index,1) ~= height) && (B{a}(index,2) ~= width))
                       plot(B{a}(index,2), B{a}(index,1),'ro', 'LineWidth', 3);                           
                       boundary = [boundary ; B{a}(index,2), B{a}(index,1)];
                   end
                   index = index + step;
               end

               ddA = diff(boundary(:,1),2);
               sharpnesses = [sharpnesses ; max(abs(ddA)), a];
           end

           sharpnesses = sortrows(sharpnesses, 1);

           orderedFigure = figure('Name','Objects ordered by Sharpness', 'Position', [10 10 1200 800]);
           hold on;

           axisvec = [];
           for i=length(sharpnesses):-1:1
               boundingBox = imageProps(sharpnesses(i,2)).BoundingBox;
               cropped = imcrop(originalImage, boundingBox);
               if (i~=length(sharpnesses))
                   imgResized = imresize(cropped, (1 + (i * 0.06)));
                   axisvec(i) = subplot(1, length(sharpnesses), i); imshow(imgResized);
               end
               if (i==length(sharpnesses))
                   imgResized = imresize(cropped, (1 + (i * 0.06)));
                   axisvec(i) = subplot(1, length(sharpnesses), i); imshow(imgResized);
               end
           end
           linkaxes(axisvec, 'x');
           openImg = 1;
           while(true)
               [xm, ym, button5] = ginput(1);
               if (button5 == 113) %Pressing q to quit
                   if(openImg == 1)
                       close(orderedFigure);
                       openImg = 0;
                   end
                   delete(t);
                   imshow(originalImage);
                   t = text(width + 50, 200, commandsOText, 'FontWeight', 'bold');
                   t.BackgroundColor = 'w';
                   t.Color = 'k';
                   t.FontSmoothing = 'on';
                   t.FontSize = 13;
                   t.Margin = 5;
                   break;
               end
           end
       end

       if (button4 == 100) %Press d - Order by relative distance
            delete(t);
            t = text(width + 50, 200, commandsODText, 'FontWeight', 'bold');
            t.BackgroundColor = 'w';
            t.Color = 'k';
            t.FontSmoothing = 'on';
            t.FontSize = 13;
            t.Margin = 5;

            while(true)
               %User has to select an object
               [xm, ym, button5] = ginput(1);

               if (button5 == 1)
                   orderedFigure = figure('Name','Objects ordered by Distance', 'Position', [10 10 1200 800]);
                   ret = lbOpened(round(ym),round(xm));
                   if (ret ~= 0)
                       listDistance = struct('Distance', {}, 'Index', {});
                       for a=1:length(inds)
                           if(a ~= ret)
                               x1 = imageProps(ret).Centroid(1);
                               y1 = imageProps(ret).Centroid(2);
                               x2 = imageProps(inds(a)).Centroid(1);
                               y2 = imageProps(inds(a)).Centroid(2);
                               distance = sqrt((x1-x2).^2 + (y1-y2).^2);

                               % Add distance to struct
                               sim = struct('Distance', distance, 'Index', inds(a));
                               listDistance = [listDistance ; sim];
                           end
                       end
                       [~, ind] = sort([listDistance.Distance]);
                       for o=1:length(ind)
                           boundingBox = imageProps(listDistance(ind(o)).Index).BoundingBox;
                           cropped = imcrop(originalImage, boundingBox);
                           if (o~=1)
                               imgResized = imresize(cropped, (1 + (o * 0.06)));
                               ax(o) = subplot(1, length(ind), o); imshow(imgResized);
                           end
                           if (o==1)
                               imgResized = imresize(cropped, o);
                               ax(o) = subplot(1, length(ind), o); imshow(imgResized);
                           end
                       end
                       linkaxes(ax, 'x');
                       openImg = 1;
                   end
               end
               if (button5 == 113) %Pressing q to quit
                   if(openImg == 1)
                       close(orderedFigure);
                       openImg = 0;
                   end
                   delete(t);
                   imshow(originalImage);
                   t = text(width + 50, 200, commandsOText, 'FontWeight', 'bold');
                   t.BackgroundColor = 'w';
                   t.Color = 'k';
                   t.FontSmoothing = 'on';
                   t.FontSize = 13;
                   t.Margin = 5;
                   break;
               end
            end
       end

       if (button4 == 113) %Pressing q to quit
           if(openImg == 1)
            close(orderedFigure);
            openImg = 0;
           end
           delete(t);
           imshow(originalImage);
           break;
       end

       if (button4 == 114) %Pressing r to reset
            if(openImg == 1)
            close(orderedFigure);
            openImg = 0;
           end
           imshow(originalImage);
       end
   end
end