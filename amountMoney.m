function amountMoney(t, inds, imageProps, coin1CentP, delta1Cent, ...
    coin2CentP, delta2Cent, coin10CentP, delta10Cent, coin5CentP, ...
    delta5Cent, coin20CentP, delta20Cent, coin1EurP, delta1Eur, ...
    coin50CentP, delta50Cent, width, originalImage)

   delete(t);
   while (true)
       %Total Value
       value = 0.0;

       for q=1:length(inds)
           if (0.98 < imageProps(q).Circularity) && (imageProps(q).Circularity < 1.1)
               if (coin1CentP - delta1Cent < imageProps(q).Area) && (imageProps(q).Area < coin1CentP + delta1Cent)
                   value = value + 0.01;
               end
               if (coin2CentP - delta2Cent < imageProps(q).Area) && (imageProps(q).Area < coin2CentP + delta2Cent)
                   value = value + 0.02;
               end
               if (coin10CentP - delta10Cent < imageProps(q).Area) && (imageProps(q).Area < coin10CentP + delta10Cent)
                   value = value + 0.10;
               end
               if (coin5CentP - delta5Cent < imageProps(q).Area) && (imageProps(q).Area < coin5CentP + delta5Cent)
                   value = value + 0.05;
               end
               if (coin20CentP - delta20Cent < imageProps(q).Area) && (imageProps(q).Area < coin20CentP + delta20Cent)
                   value = value + 0.20;
               end
               if (coin1EurP - delta1Eur < imageProps(q).Area) && (imageProps(q).Area < coin1EurP + delta1Eur)
                   value = value + 1.00;
               end
               if (coin50CentP - delta50Cent < imageProps(q).Area) && (imageProps(q).Area < coin50CentP + delta50Cent)
                   value = value + 0.50;
               end
           end
       end

       values = {num2str(value), char(8364)};
       valueText = strjoin(values, ' ');
       commandsA = {'Amount of money in image:', valueText, ' ', 'Press:', 'q - quit'};
       commandsAText = strjoin(commandsA, '\n');

       t = text(width + 50, 200, commandsAText, 'FontWeight', 'bold');
       t.BackgroundColor = 'w';
       t.Color = 'k';
       t.FontSmoothing = 'on';
       t.FontSize = 13;
       t.Margin = 5;

       [xo, yo, buttonA] = ginput(1);

       if (buttonA == 113) % Press q to quit
           delete(t);
           imshow(originalImage);
           break;
       end
   end