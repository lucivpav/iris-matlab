% circle - [x0, y0, r]
% spline - [p1, p2, mid_pt]

% circles - two circle rows describing iris
%         - first row: inner circle
%         - second row: outer circle
% eyelids - one or two spline rows describing eyelid
function [circles, eyelids] = segment(eye_image)
  global CUR_DIR;
  inner_circle = find_inner_circle(eye_image);
  outer_circle = find_outer_circle(eye_image, inner_circle);
  eyelids = find_eyelid_boundaries(eye_image, inner_circle, outer_circle);
  circles = [inner_circle; outer_circle];

  % debug
  for i=1:size(circles,1)
    eye_image = plot_circle(eye_image, circles(i,:));
  end
  for i=1:size(eyelids)
    eye_image = plot_spline(eye_image, eyelids(i,:));
  end
  save_image(eye_image, 'segmented');
end

% boundaries -  matrix whose rows describe eyelid boundary lines
function boundaries = find_eyelid_boundaries(eye_image, ...
                                             inner_circle, ...
                                             outer_circle)
  eye_image = im2single(eye_image);
  angle_accuracy = 20;
  line_step = 10;
  boundaries = [];
  angle = 0;
  prev = -1;
  prev_spline = [-1,-1,-1,-1,-1,-1]; % points p1, p2, mid_pt
  best_splines = [];
  cap = 60;
  while angle < pi
    dir = [cos(angle), sin(angle)];
    norm = [dir(2), -dir(1)];
    orig = inner_circle(1:2);
    line = [dir, orig];

    base_mid_pt = orig+4*norm;
    while point_circle_relation(base_mid_pt, outer_circle) < 0
      k = 0;
      while 1
        line(1,3:4) = orig + k*norm;
        mid_pt = base_mid_pt + k*norm;

        if point_circle_relation(mid_pt, outer_circle) >= 0
          break;
        end

        int = line_circle_intersect(line, outer_circle);
        spline = [int(1,:), int(2,:), mid_pt];
        cur = spline_average(eye_image, spline, inner_circle);

        if ( prev ~= -1 )
          diff = abs(prev-cur);

          % check if it belongs to top solutions
          back = size(best_splines,1);
          if back == 0
            best_splines = [diff, prev_spline];
          elseif back < cap
            best_splines(back+1,:) = [diff, prev_spline];
          elseif diff > best_splines(back, 1)
            best_splines(back,:) = [diff, prev_spline];
            best_splines = sortrows(best_splines, [-1]);
          end

          prev_spline = [int(1,:), int(2,:), mid_pt];
        end
        prev = cur;
        k = k + line_step;
      end
      base_mid_pt = base_mid_pt + 4*norm;
      prev = -1;
    end
    angle = angle + pi/angle_accuracy;
  end
  n_splines = size(best_splines,1);
  boundaries = best_splines(1,2:7);
  first_spline = best_splines(1,2:7);
  second_spline_candidates = best_splines(2:n_splines, 2:7);
  [splines,idx] = remove_intersecting_splines(first_spline, ...
                                        second_spline_candidates);
  if size(idx,1) > 0 && best_splines(idx(1),1) > 0.1
    boundaries = [boundaries; splines(1,:)];
  end
end

function [splines,idx] = remove_intersecting_splines(pivot_spline, splines_)
  splines = [];
  idx = [];
  p1 = pivot_spline(1:2);
  p2 = pivot_spline(3:4);
  mid_pt = pivot_spline(5:6);
  for i=1:size(splines_)
    spline = splines_(i,:);
    for j=0:2
      p = spline(j*2+1:j*2+2);
      from = p1-mid_pt;
      to = p2-mid_pt;
      x = p-mid_pt;
      if (cross2d(from,x)*cross2d(from,to) <= 0 ...
         || cross2d(to,x)*cross2d(to,from) <= 0 )
        break;
      end
      if j == 2
        dist = min([norm(p1-spline(1:2)),
                    norm(p2-spline(3:4)),
                    norm(p2-spline(1:2)),
                    norm(p1-spline(3:4))]);
        if dist > 40
          splines = [splines; splines_(i,:)];
          idx = [idx; i];
        end
      end
    end
  end
end

function z = cross2d(vec1, vec2)
  z = cross([vec1,0], [vec2,0]);
  z = z(3);
end

% point - [x, y]
% circle - [x0, y0, r]
% relation:  positive if point outside of circle
%            zero if point on of circle
%            negative if point inside of circle
function relation = point_circle_relation(point, circle)
  x = point(1);
  y = point(2);
  x0 = circle(1);
  y0 = circle(2);
  r = circle(3);
  relation = (x-x0)^2 + (y-y0)^2 - r^2;
end

function average = spline_average(image, spline, circle_to_avoid)
  points = sample_spline(image, spline);
  summ = 0;
  n = 0;
  for i=1:size(points)
    p = points(i,:);
    if point_circle_relation(p, circle_to_avoid) > 0
      summ = summ + image(p(2), p(1));
      n = n + 1;
    end
  end
  average = summ/n;
end

% line - [fromx, fromy, tox, toy]
function average = line_average(image, line)
  points = sample_line(image, line);
  summ = 0;
  n = size(points,1);

  % calc median
  values = [];
  for p=1:n
    values = [values; image(points(p,2), points(p,1))];
  end

  values = sort(values);
  average = values(floor(size(values,1)/2)+1);
  return;

  % alternative: calc average
  for p=1:n
    summ = summ + image(points(p,2), points(p,1));
  end
  average = double(summ)/n;
end

% Finds the best candidate for an inner circle.
% eye_image - grayscale image of an eye
% circle - vector which describes an inner circle [x, y, r]
% TODO: ensure this won't find outer circle
function circle = find_inner_circle(eye_image)
  edge_image = edge(eye_image, 'Canny', 2.5);
  save_image(edge_image, 'inner_circle_input')
  % focus search to the centre of eye image
  % TODO: decide search region in a more clever way
  %       currently region too big -> slow
  offset = round(0.38 * size(edge_image)); % [height, width]
  area = [offset(2), size(edge_image,2)-2*offset(2);
          offset(1), size(edge_image,1)-2*offset(1)];
  radius = [40, 70]; % TODO
  circle_to_avoid = [-1, -1, -1];
  circle = find_circle_in_area(edge_image, area, radius, circle_to_avoid);
  circle(3) = circle(3) + 1;
  return;
end

function val = point_value(image, pos, dir)
  n = 2;
  values = [];
  for i=-n:n
    p = round(pos+i*dir);
    if ( p(1) < 1 || p(2) < 1 || ...
         p(1) > size(image,2) || ...
         p(2) > size(image,1) )
      continue;
    end
    value = image(p(2),p(1));
    values = [values value];
  end
  % average
  %val = sum(values)/size(values,2);
  % median
  val = sort(values)(round(size(values,2)/2));
end

function circle = find_outer_circle(eye_image, inner_circle)
  img = eye_image;
  angle_steps = 40;
  angle_step = 2*pi/angle_steps;
  step = 7;
  thresh = 10;
  points = [];

  orig = inner_circle(1:2);
  for i=1:angle_steps
    prev = -1;
    dir = [cos(i*angle_step) sin(i*angle_step)];
    pos = round(orig + (inner_circle(3)+10)*dir);
    while 1
      if ( pos(1) < 1 || pos(2) < 1 || ...
           pos(1) > size(eye_image,2) || ...
           pos(2) > size(eye_image,1) || ...
           norm(pos-orig) > 200 )
        break;
      end
      cur = point_value(eye_image, pos, dir);
      if prev ~= -1
        diff = abs(cur-prev);
        if diff > thresh
          point = round(pos - dir/2);
          points = [points; point];
          break;
        end
      end
      prev = cur;
      pos = round(pos + step*dir);
    end
  end
  N = size(eye_image,1);
  M = size(eye_image,2);
  edge_image = zeros(size(eye_image));
  for i=1:size(points,1)
    p = points(i,:);
    edge_image(points(i,2),points(i,1)) = 1;
    % point clouds
    t = 1;
    fromx = max(0,p(1)-t);
    fromy = max(0,p(2)-t);
    tox = min(M,p(1)+t);
    toy = min(N,p(2)+t);
    edge_image(fromy:toy,fromx:tox) = 1;
  end
  save_image(edge_image, 'outer_circle_input');
  % focus search near inner circle centre
  offset = round(0.02 * size(img)); % [height, width]
  area = [inner_circle(1)-offset(2), 2*offset(2),
          inner_circle(2)-offset(1), 2*offset(1)];
  % TODO: r might be up to 10x
  radius = [40+inner_circle(3), 3*inner_circle(3)];
  circle = find_circle_in_area(edge_image, area, radius, inner_circle);
  circle(3) = circle(3) - 1;

  P = size(points,1);
  for i=1:P-1
    eye_image = plot_line(eye_image, [points(i,:) points(i+1,:)]);
    i = i+1;
  end
  eye_image = plot_line(eye_image, [points(1,:) points(P,:)]);
  save_image(eye_image, 'outer_circle_input_visualized');
end

% Finds the best candidate for a circle given restrictions.
% eye_image - grayscale image of an eye
% area - an area description [x0, width; y0, height] within which to search
%        for circle centers
% raridus - radius interval [r_min, r_max] to be considered as circle
% circle_to_avoid - circle [x, y, r] that cannot be interested by
%                   a circle we are looking for.
%                   Use [-1, -1, -1] if no such circle
% circle - description of the circle [x, y, r]
function circle = find_circle_in_area(edge_image, area, radius, circle_to_avoid)
  img = edge_image;

  % 1 - high but slow, 10 - low but fast
  radius_accuracy = 3;
  center_accuracy = 2;

  % difficulty (number of circle centers considered)
  %disp(['difficulty: ', num2str( area(1,2) * area(2,2) )]); % debug

  best_avg = 0;
  best_circle = [42, 42, 42];
  y = area(2,1);
  while y <= area(2,1)+area(2,2)
    x = area(1,1);
    while x <= area(1,1)+area(1,2)
      r = radius(1);
      while r <= radius(2)
        % ensure radius within image bounds
        xdiff = min(x-1, size(img,2)-x);
        ydiff = min(y-1, size(img,1)-y);
        diff = min(xdiff, ydiff);
        if ( r > diff )
          break;
        end

        circle = [x, y, r];
        avg = circle_average(img, circle);

        % update best circle
        if ( avg > best_avg )
          if ( circle_to_avoid ~= [-1, -1, -1] )
            if ( circle_intersect(circle, circle_to_avoid) )
              continue;
            end
          end
          best_circle = circle;
          best_avg = avg;
        end
        r = r + radius_accuracy; % TODO: logarithmic steps? (faster)
      end
      x = x + center_accuracy;
    end
    y = y + center_accuracy;
  end
  % TODO: after finding approximate solution, try to find the "best" in
  % neigbourhood - we have skipped (depending on accuracy) several circle
  % settings
  circle = best_circle;
end

% Returns true if circles intersect, false otherwise.
% circle - description of the circle [x, y, r]
function intersect = circle_intersect(circle1, circle2)
  x1 = circle1(1);
  y1 = circle1(2);
  r1 = circle1(3);

  x2 = circle2(1);
  y2 = circle2(2);
  r2 = circle2(3);

  centers_distance = (x1-x2)^2 + (y1-y2)^2;
  intersect = (r1-r2)^2 <= centers_distance && centers_distance <= (r1+r2)^2;
end
