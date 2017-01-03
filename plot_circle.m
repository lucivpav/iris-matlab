% image - grayscale 2D matrix image to plot into
% circle - description of the circle [x, y, r]
% image_result - image with the circle plotted
function image = plot_circle(image, circle)
  color = 0.3;
  accuracy = 2; % 1 - high but slow, 10 - low but fast

  x0 = circle(1);
  y0 = circle(2);
  r = circle(3);
  x = -r;
  while x<=r
    if ( x+x0 <= 0 || x+x0 > size(image,2) )
      continue;
    end
    tmp = round(sqrt(r*r-x^2));
    y1 = tmp+y0;
    y2 = -tmp+y0;

    if ( y1 > 0 && y1 <= size(image,1) )
      image(y1, x+x0) = color;
    end

    if ( y2 > 0 && y2 <= size(image,1) )
      image(y2, x+x0) = color;
    end

    x = x + accuracy;
  end
  image_result = image;
end
