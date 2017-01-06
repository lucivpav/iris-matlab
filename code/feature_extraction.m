% image - iris image in radial coordinates
function iris_code = feature_extraction(image)
  minWaveLength = 18;
  mult = 1; % not applicable if using nscales = 1
  sigmaOnf = 0.5;
  [E0 filtersum] = gabor_convolve(image, 1, minWaveLength, mult, sigmaOnf);
  iris_code = phase_quantization(E0{1});
end
