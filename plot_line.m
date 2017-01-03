% line - [fromx, fromy, tox, toy]
function new_image = plot_line(image, line)
  new_image = image;
  points = sample_line(image, line);
  for p=1:size(points,1)
    new_image(points(p,2), points(p,1)) = 0;
  end
end
