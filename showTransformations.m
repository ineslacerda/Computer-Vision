function showTransformations(t, width, height, commandsTText,...
    originalImage, lbOpened, imageProps, opened, commandsTOptionText)   
   delete(t);      
   t2 = text(width + 50, 200, commandsTText, 'FontWeight', 'bold');
   t2.BackgroundColor = 'w';
   t2.Color = 'k';
   t2.FontSmoothing = 'on';
   t2.FontSize = 13;
   t2.Margin = 5;
   ret = 0
   boundingBox = 0;
   cropped = 0;
   transformed = 0;
   while(true)
       if transformed==0
           imshow(originalImage);
       end
       %User has to select an object
       [xm, ym, button5] = ginput(1);
       if (button5 == 1) %click
         ret = lbOpened(round(ym),round(xm));
         if(ret ~= 0)
            boundingBox = imageProps(ret).BoundingBox;
            cropped = imcrop(originalImage, boundingBox);
            
            %Plot object boundaries
            [B, L, N, A] = bwboundaries(opened);

            boundary = B{ret};
            plot(boundary(:,2), boundary(:,1), 'k--', 'LineWidth',3);

            [xm, ym, button6] = ginput(1);

           if(button6 == 49) % 1 - Rotate Right
                %imshow(translated);
                rotated = imrotate(cropped, 270);
                figure('Name','Transformed Image'), hold on, imshow(originalImage, 'InitialMagnification', 'fit');
                image(rotated, 'XData', [imageProps(ret).BoundingBox(1) imageProps(ret).BoundingBox(1)+imageProps(ret).BoundingBox(3)], 'YData', [imageProps(ret).BoundingBox(2) imageProps(ret).BoundingBox(2)+imageProps(ret).BoundingBox(4)]);
                transformed = 1;
           end
           if(button6 == 50) % 2 - Rotate Left
                %imshow(translated);
                rotated = imrotate(cropped, 90);
                figure('Name','Transformed Image'), hold on, imshow(originalImage, 'InitialMagnification', 'fit');
                image(rotated, 'XData', [imageProps(ret).BoundingBox(1) imageProps(ret).BoundingBox(1)+imageProps(ret).BoundingBox(3)], 'YData', [imageProps(ret).BoundingBox(2) imageProps(ret).BoundingBox(2)+imageProps(ret).BoundingBox(4)]);
                transformed = 1;
           end
           if(button6 == 51) % 3 - Flip upside-down
                %imshow(translated);
                flipped = flipud(cropped);
                figure('Name','Transformed Image'), hold on, imshow(originalImage, 'InitialMagnification', 'fit');
                image(flipped, 'XData', [imageProps(ret).BoundingBox(1) imageProps(ret).BoundingBox(1)+imageProps(ret).BoundingBox(3)], 'YData', [imageProps(ret).BoundingBox(2) imageProps(ret).BoundingBox(2)+imageProps(ret).BoundingBox(4)]);
                transformed = 1;
           end
           if(button6 == 52) % 4 - Flip upside-down
                %imshow(translated);
                flipped = fliplr(cropped);
                figure('Name','Transformed Image'), hold on, imshow(originalImage, 'InitialMagnification', 'fit');
                image(flipped, 'XData', [imageProps(ret).BoundingBox(1) imageProps(ret).BoundingBox(1)+imageProps(ret).BoundingBox(3)], 'YData', [imageProps(ret).BoundingBox(2) imageProps(ret).BoundingBox(2)+imageProps(ret).BoundingBox(4)]);
                transformed = 1;
           end
           if(button6 == 53) % 5 - Scale 2 x 2
                %imshow(translated);
                scaled = imresize(cropped, .5, 'nearest');
                figure('Name','Transformed Image'), hold on, imshow(originalImage, 'InitialMagnification', 'fit');
                imshow(scaled, 'XData', [imageProps(ret).BoundingBox(1) imageProps(ret).BoundingBox(1)+imageProps(ret).BoundingBox(3)*2], 'YData', [imageProps(ret).BoundingBox(2) imageProps(ret).BoundingBox(2)+imageProps(ret).BoundingBox(4)*2]);
                transformed = 1;
           end
          end 
       end  
       if (button5 == 114) % Press r to return
            delete(t2);
            imshow(originalImage);
            break;
       end 
       if(transformed == 1)
            t3 = text(250, height + 100, commandsTOptionText, 'FontWeight', 'bold');
            t3.BackgroundColor = 'w';
            t3.Color = 'k';
            t3.FontSmoothing = 'on';
            t3.FontSize = 13;
            t3.Margin = 5;
       end

       if (button5 == 113) % Press q to close new window
           transformed = 0;
           close;
       end
   end
end