function iris_code = phase_quantization(features)
  iris_code = zeros(size(features,1),2*size(features,2));
  for m = 1:size(features,1)
    for n = 1:size(features,2)
      if real(features(m,n)) >= 0
        if imag(features(m,n)) >= 0
          iris_code(m,2*n-1:2*n) = [1 1];
        else
          iris_code(m,2*n-1:2*n) = [1 0];
        end
      else
        if imag(features(m,n)) >= 0
          iris_code(m,2*n-1:2*n) = [0 1];
        else
          iris_code(m,2*n-1:2*n) = [0 0];
        end
      end
    end
  end
end
