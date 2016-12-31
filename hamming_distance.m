function [hamming_distance]  = hamming_distance(iris_code1,iris_code2,mask_size)
    hamming_distance = sum(sum(abs(iris_code1-iris_code2)))/mask_size;
end

