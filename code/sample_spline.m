% spline - [p1, p2, mid_pt]
function points = sample_spline(image, spline_)
  points = [];
  samples = 15;

  p1 = spline_(1:2);
  p2 = spline_(3:4);
  mid_pt = spline_(5:6);

  dist = norm(p2-p1);
  dir = (p2-p1)/dist;
  line_mid_pt = p1+dir*dist/2;
  mid_pt_dist = norm(mid_pt-line_mid_pt);
  normal = (mid_pt-line_mid_pt)/mid_pt_dist;

  x = [0, dist, dist/2];
  y = [0, 0, mid_pt_dist];
  xx = 0:dist/samples:dist;
  yy = spline(x, y, xx);
  for i=1:size(xx,2)
    p = round(p1+xx(i)*dir+yy(i)*normal);
    if (p(1) > 0 && p(1) <= size(image, 2) ...
       && p(2) > 0 && p(2) <= size(image, 1))
      points = [points; p];
    end
  end
  points = [p1; points; p2];
end
