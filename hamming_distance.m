function dist = hamming_distance(iris_code1, iris_code2, mask_size)
  dist = sum(sum(abs(iris_code1-iris_code2))) / mask_size;
end
