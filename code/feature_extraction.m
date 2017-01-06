% image - iris image in radial coordinates
function iris_code = feature_extraction(image)
%   features = [];
%   gabor_wavelet = gabor_wavelet_2d(39,39,1,8);
%   for scale = 1:size(gabor_wavelet,1)
%     for orientation = 1:size(gabor_wavelet,2)
%       features = [features;
%                   imfilter(image,gabor_wavelet{scale,orientation})];
%     end
%   end
%   iris_code = phase_quantization(features);
    minWaveLength=18;
    mult=1; % not applicable if using nscales = 1
    sigmaOnf=0.5;
    [E0 filtersum] = gaborconvolve(image, 1, minWaveLength, mult, sigmaOnf);
    iris_code = phase_quantization(E0{1});
end

