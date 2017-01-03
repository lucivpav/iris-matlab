% wavelet - wavelet (size u,v) for 2d gabor filter
% width  - number of columns in 2d gabor kernel (an odd integer number)
% height - number of rows in 2d gabor kernel (an odd integer number)
% u - number of scales
% v - number of orientations

function wavelet = gabor_wavelet_2d(width,height,u,v)

% M. Haghighat, S. Zonouz, M. Abdel-Mottaleb, "CloudID: Trustworthy 
% cloud-based and cross-enterprise biometric identification," 
% Expert Systems with Applications, vol. 42, no. 21, pp. 7905-7916, 2015.

  wavelet = cell(u,v);

  fmax = 0.25;
  gamma = sqrt(2);
  eta = sqrt(2);

  for ui = 1:u
    fu = fmax/((sqrt(2))^(ui-1));
    alpha = fu/gamma;
    beta = fu/eta;
    for vi = 1:v
      thetav = ((vi-1)/v)*pi;
      kernel = zeros(height,width);
      for x = 1:width
        for y = 1:height
          x_centered = x-(width+1)/2;
          y_centered = y-(height+1)/2;
          x_prime = x_centered * cos(thetav) + y_centered * sin(thetav);
          y_prime = -x_centered * sin(thetav) + y_centered * cos(thetav);
          kernel(y,x) = ((fu^2/(pi*gamma*eta))*exp(-((alpha^2)*(x_prime^2)+(beta^2)*(y_prime^2)))*exp(1i*2*pi*fu*x_prime));
        end
      end
      wavelet{ui,vi} = kernel;
    end
  end
end
