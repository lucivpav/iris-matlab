% gabor_convolve - convolve each row of an image with 1D log-Gabor filters
% im            - the image to convolve
% nscale        - number of filters to use
% minWaveLength - wavelength of the basis filter
% mult          - multiplicative factor between each filter
% sigmaOnf      - ratio of the standard deviation of the Gaussian describing
%                 the log Gabor filter's transfer function in the frequency
%                 domain to the filter center frequency
% E0            - a 1D cell array of complex valued comvolution results
%
% Author:
% Original 'gabor_convolve' by Peter Kovesi, 2001
% Heavily modified by Libor Masek, 2003
% masekl01@csse.uwa.edu.au
function [EO, filtersum] = gabor_convolve(im, nscale, minWaveLength, ...
                                          mult, sigmaOnf)
  [rows cols] = size(im);
  filtersum = zeros(1,size(im,2));
  EO = cell(1, nscale); % pre-allocate cell array
  ndata = cols;
  if mod(ndata,2) == 1 % if there is an odd No of data points
    ndata = ndata-1;   % throw away the last one
  end

  logGabor  = zeros(1,ndata);
  result = zeros(rows,ndata);

  radius =  [0:fix(ndata/2)]/fix(ndata/2)/2; % frequency values 0 - 0.5
  radius(1) = 1;

  wavelength = minWaveLength; % initialize filter wavelength

  for s = 1:nscale % for each scale
    % construct the filter - first calculate the radial filter component
    fo = 1.0/wavelength; % centre frequency of filter
    logGabor(1:ndata/2+1) = exp((-(log(radius/fo)).^2) ...
                            / (2*log(sigmaOnf)^2));
    logGabor(1) = 0;
    filter = logGabor;
    filtersum = filtersum+filter;

    % for each row of the input image, do the convolution, back transform
    for r = 1:rows % For each row
      signal = im(r,1:ndata);
      imagefft = fft( signal );
      result(r,:) = ifft(imagefft .* filter);
    end

    % save the ouput for each scale
    EO{s} = result;

    % calculate wavelength of next filter
    % and process the next scale
    wavelength = wavelength * mult;
  end
  filtersum = fftshift(filtersum);
end
