function [smallest_distance] = smallest_distance(iris_code1,iris_code2)
    smallest_distance = Inf;
    for perm = 1:size(iris_code1,2)
        current_distance = hamming_distance(iris_code1,iris_code2);
        if current_distance < smallest_distance
            smallest_distance = current_distance;
        end
        iris_code2 = circshift(iris_code2,1,2);
    end
end

