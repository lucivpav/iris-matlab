% image - grayscale 2D matrix image to plot into
% circle - description of the circle [x, y, r]
function points = sample_circle(image, circle)
  points = [];
  angle_steps = 40;
  angle_step = 2*pi/angle_steps;
  orig = circle(1:2);
  r = circle(3);
  for i=1:angle_steps
    dir = [cos(i*angle_step) sin(i*angle_step)];
    pos = round(orig+r*dir);
    if ( pos(1) < 1 || pos(2) < 1 || ...
         pos(1) > size(image,2) || ...
         pos(2) > size(image,1) )
      continue;
    end
    points = [points; pos];
  end
end
