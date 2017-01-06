% line - [dirx, diry, origx, origy] where dir has unit length
% circle - [x, y, r]
function points = line_circle_intersect(line, circle)
  points = [];
  x0 = circle(1);
  y0 = circle(2);
  r = circle(3);
  if ( line(2) == 1 ) % vertical line
    x = line(3);
    y_pow2 = r*r-(x-x0)^2;
    if ( y_pow2 == 0 )
      y = round(sqrt(y_pow2))+y0;
      points = round([x, y]);
    elseif ( y_pow2 > 0 )
      tmp = round(sqrt(y_pow2));
      y1 = tmp+y0;
      y2 = -tmp+y0;
      points = round([x, y1; x, y2]);
    end
    return;
  end

  k = line(2) / line(1);
  q = line(4) - k*line(3);
  x0 = circle(1);
  y0 = circle(2);
  r = circle(3);

  a = 1+k^2;
  b = -2*x0 + 2*k*q - 2*k*y0;
  c = -r^2 + q^2 - 2*q*y0 + y0^2 + x0^2;
  D = b^2 - 4*a*c;
  if ( D == 0 )
    x = -b/(2*a);
    y = k*x+q;
    points = round([x, y]);
  elseif ( D > 0 )
    x1 = ( -b + sqrt(D) ) / (2*a);
    x2 = ( -b - sqrt(D) ) / (2*a);
    y1 = k*x1+q;
    y2 = k*x2+q;
    points = round([x1, y1; x2, y2]);
  end
end
