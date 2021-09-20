function showSharpness(t, width, commandsG1, commandsG2Text, lbOpened,...
    opened, originalImage)
   delete(t);
   while(true)
       tG1 = text(width + 50, 200, commandsG1, 'FontWeight', 'bold');
       tG1.BackgroundColor = 'w';
       tG1.Color = 'k';
       tG1.FontSmoothing = 'on';
       tG1.FontSize = 13;
       tG1.Margin = 5;

       [x0, y0, button4] = ginput(1);
       delete(tG1);

       if (button4 == 1)
           tG2 = text(width + 50, 200, commandsG2Text, 'FontWeight', 'bold');
           tG2.BackgroundColor = 'w';
           tG2.Color = 'k';
           tG2.FontSmoothing = 'on';
           tG2.FontSize = 13;
           tG2.Margin = 5;
           % Object that was clicked on
           ret = lbOpened(round(y0),round(x0));
           if (ret ~= 0)
               hold on
               [B,L,N] = bwboundaries(opened);
               boundary = B{ret};

               plot(boundary(:,2), boundary(:,1), 'k--', 'LineWidth', 4);

               % Gets number of points to show in boundary from console
               fprintf('\nChoose number of points:\n');
               nrPoints = input('>> ');             

               % Compute step to use when traversing matrix
               step = round(length(B{ret})/nrPoints);
               index = 1;
               a = [];
               b = [];

               % Plot points over boundary
               for l=1:nrPoints
                   plot(B{ret}(index,2), B{ret}(index,1),'ro', 'LineWidth', 3);
                   a = [a ; B{ret}(index,2), B{ret}(index,1)];
                   index = index + step;
               end

               % Determine derivative between chosen points
               for m=1:length(a)
                   % Check if it is the last el
                   % Determine derivative between last and first el
                   if(a(end,:) == a(m,:))
                      slope = (a(1,2) - a(m,2))/(a(1,1) - a(m,1));
                      b = [b ; slope]; 
                      break;
                   end
                   slope = (a(m+1,2) - a(m,2))/(a(m+1,1) - a(m,1));
                   b = [b ; slope];
               end

               % Create graph
               graphFigure = figure('Name', 'Derivative graph');
               a(end,:) = [];
               x = [1:1:length(b)];
               x = x.';
               y = b;
               graph = plot(x,y);
               graph.LineWidth = 2;
               graph.Color = 'r';
               ax = gca;
               ax.XAxisLocation = 'origin'; 

               while(true)
                   % Wait for input on graph window
                   [xg, yg, buttonGraph] = ginput(1);

                   if (buttonGraph == 113) % Press q to close graph
                       close(graphFigure);
                       break;
                   end
               end

               delete(tG2);

               points = findobj('type','line');
               delete(points);

           end
       end       

       if (button4 == 113) % Press q to quit
           imshow(originalImage);
           break;
       end
   end
end