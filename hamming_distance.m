function [hamming_distance]  = hamming_distance(iris_code1,iris_code2)
    hamming_distance = sum(sum(abs(iris_code1-iris_code2)))/(size(iris_code1,1)*size(iris_code1,2));
end

