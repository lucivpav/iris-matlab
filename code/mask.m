function mask_image = mask(eye_image, circles, eyelids)
  mask_image = eye_image;
  points = [];
  for i=1:size(eyelids,1)
    spline = eyelids(i,:);
    points = [points; sample_spline(eye_image, spline)];
  end

  center = circles(2,1:2);
  for i=1:size(eye_image,1)
    for j=1:size(eye_image,2)
      point = [j,i]; % [x,y]

      % find nearest spline point
      k = dsearchn(points,point);
      spline_point = points(k,:);

      % check whether point inside of eyelid boundaries
      if ( norm(point-center) > norm(spline_point-center) )
        mask_image(i,j) = 0;
      else
        mask_image(i,j) = 255;
      end
    end
  end

  % debug
  image = mask_image;
  for i=1:size(circles,1)
    image = plot_circle(image, circles(i,:));
  end
  for i=1:size(eyelids)
    image = plot_spline(image, eyelids(i,:));
  end
  save_image(mask_image, 'mask');
end
