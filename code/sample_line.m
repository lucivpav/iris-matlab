% line - [fromx, fromy, tox, toy]
function points = sample_line(image, line)
  accuracy = 50;
  points = [];
  from = line(1:2);
  to = line(3:4);
  dist = norm(from-to);
  if ( dist == 0 )
    return;
  end

  step_size = dist / accuracy;
  step = (to-from) / accuracy;

  if from(1) == to(1) % vertical line
    x = from(1);
    y = min(from(2), to(2));
    for i=1:accuracy+1
      tmp = y;
      y = round(y);
      if ( x > 0 && x <= size(image,2) && ...
           y > 0 && y <= size(image,1) )
        points = [points; x, y];
      end
      y = tmp + step_size;
    end
    return;
  end

  k = step(2) / step(1);
  q = from(2) - k*from(1);
  x_step = sqrt( step_size^2 - step(2)^2 );

  x=min(from(1), to(1));
  for i=1:accuracy+1
    y = round(k*x+q);
    tmp = x;
    x = round(x);
    if ( x > 0 && x <= size(image,2) && ...
         y > 0 && y <= size(image,1) )
      points = [points; x, y];
    end
    x = tmp + x_step;
  end
end
