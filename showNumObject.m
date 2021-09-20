function showNumObject(t, width, commandsNText, originalImage)       
   delete(t);
   while(true)
       t = text(width + 50, 200, commandsNText, 'FontWeight', 'bold');
       t.BackgroundColor = 'w';
       t.Color = 'k';
       t.FontSmoothing = 'on';
       t.FontSize = 13;
       t.Margin = 5;

       [xm, ym, button2quit] = ginput(1);

       if (button2quit == 114) %Pressing r to return
           delete(t);
           imshow(originalImage);
           break;
       end 
   end
end