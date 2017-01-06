% image - grayscale 2D matrix image to plot into
% circle - description of the circle [x, y, r]
function average = circle_average(image, circle)
  values = [];
  points = sample_circle(image, circle);
  for i=1:size(points, 1)
    pos = points(i,:);
    values = [values image(pos(2), pos(1))];
  end
  average = sum(values)/size(values,2);
end
