function computeDistances(t, width, commandsD, lbOpened, originalImage, ...
    inds, imageProps)   
   delete(t);
   t = text(width + 50, 200, commandsD, 'FontWeight', 'bold');
   t.BackgroundColor = 'w';
   t.Color = 'k';
   t.FontSmoothing = 'on';
   t.FontSize = 13;
   t.Margin = 5;

   t1 = 0;

   while(true)
       [x0, y0, button4] = ginput(1);

       if (button4 == 1)
           % Object that was clicked on
           ret = lbOpened(round(y0),round(x0));
           if (ret ~= 0)
               imshow(originalImage);
               % Compute distance between objects
               listDistance = struct('Distance', {}, 'Index', {});
               totalDistance = 0;
               for a=1:length(inds)
                   if(a ~= ret)
                       x1 = imageProps(ret).Centroid(1);
                       y1 = imageProps(ret).Centroid(2);
                       x2 = imageProps(inds(a)).Centroid(1);
                       y2 = imageProps(inds(a)).Centroid(2);
                       distance = sqrt((x1-x2).^2 + (y1-y2).^2);
                       totalDistance = totalDistance + distance;

                       % Add distance to struct
                       sim = struct('Distance', distance, 'Index', inds(a));
                       listDistance = [listDistance ; sim];
                   end
               end

               [sorted, ind] = sort([listDistance.Distance]);

               for a=1:length(ind)
                   x1 = imageProps(ret).Centroid(1);
                   y1 = imageProps(ret).Centroid(2);
                   x2 = imageProps(listDistance(ind(a)).Index).Centroid(1);
                   y2 = imageProps(listDistance(ind(a)).Index).Centroid(2);
                   plot([round(x1) round(x2)], [round(y1) round(y2)], 'k', 'LineWidth', 0.5 + 0.8 * a);
                   plot(x2, y2, 'ro', 'LineWidth', 6);
               end

               if t1 ~= 0
                   delete(t1);
               end

               texto = {'Total relative distance: ', ' ', totalDistance};
               t1 = text(width + 50, 500, texto, 'FontWeight', 'bold');
               t1.BackgroundColor = 'w';
               t1.Color = 'k';
               t1.FontSmoothing = 'on';
               t1.FontSize = 13;
               t1.Margin = 5;

               % Plot centroid of chosen region
               plot(imageProps(ret).Centroid(1), imageProps(ret).Centroid(2), 'ro', 'LineWidth', 6);
           end
       end
       if (button4 == 114) % Press r to reset
           if t1 ~= 0
               delete(t1);
           end
           imshow(originalImage);
       end

       if (button4 == 113) % Press q to quit
           if t1 ~= 0
               delete(t1);
           end
           delete(t);
           imshow(originalImage);
           break;
       end
   end
end