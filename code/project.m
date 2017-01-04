% circles - [inner_circle; outer_circle]
% rect - radius_samples x angle_samples matrix
function [image, rect] = project(eye_image, circles)
  image = eye_image; % debug
  radius_samples = 8;
  angle_samples = 128;
  spacing = 0.02; % percentage of space between two circles to ignore
  rect = zeros(radius_samples, angle_samples);
  for i=1:angle_samples/2
    angle = i*2*pi/angle_samples;
    dir = [cos(angle),sin(angle)];
    orig = circles(1,1:2);
    int = line_circle_intersect([dir,orig],circles(2,:));
    for j=1:radius_samples
      if sign(int(1,:)-orig) ~= sign(dir)
        tmp = int(1,:);
        int(1,:) = int(2,:);
        int(2,:) = tmp;
      end
      for k=0:1
        r_diff = norm(orig-int(k+1,:))-circles(1,3);
        r_diff = r_diff - r_diff*spacing;
        r = circles(1,3) + r_diff*spacing/2;
        r = r + (j-1)*r_diff/(radius_samples-1);
        y_from = round(r*sin(angle+k*pi))+orig(2);
        x_from = round(r*cos(angle+k*pi))+orig(1);
        x = i+k*angle_samples/2;
        rect(j,x) = eye_image(y_from, x_from);
        image(y_from,x_from) = 0; % debug
      end
    end
  end
end
