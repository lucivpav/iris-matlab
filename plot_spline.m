function new_image = plot_spline(image, spline)
  new_image = image;
  points = sample_spline(image, spline);
  for i=1:size(points)-1
    from = points(i,:);
    to = points(i+1,:);
    new_image = plot_line(new_image, [from, to]);
  end
end
