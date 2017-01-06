% image - grayscale 2D matrix image to plot into
% circle - description of the circle [x, y, r]
% image_result - image with the circle plotted
function image_result = plot_circle(image, circle)
  image_result = image;
  points = sample_circle(image, circle);
  n = size(points,1);
  for i=1:n-1
    image_result = plot_line(image_result, [points(i,:) points(i+1,:)]);
    i = i+1;
  end
  image_result = plot_line(image_result, [points(1,:) points(n,:)]);
end
