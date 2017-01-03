function dist = smallest_distance(iris_code1, iris_code2, mask1, mask2)
  dist = Inf;
  mask_once = mask1.*mask2;
  mask = mask_once;
  n = 1;
  while n < size(iris_code1,1)/size(mask1,1)
      mask = [mask;mask_once];
      n = n + 1;
  end
  mask_size = sum(sum(mask));
  iris_code1 = iris_code1.*mask;
  iris_code2 = iris_code2.*mask;
  for perm = 1:size(iris_code1, 2)
   cur = hamming_distance(iris_code1, iris_code2, mask_size);
   if cur < dist
     dist = cur;
   end
   iris_code2 = circshift(iris_code2, 1);
  end
end
