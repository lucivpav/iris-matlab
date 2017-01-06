function [mask_code] = adjust_mask(mask_rect,iris_code_row_n)
    % duplicate each column to be compatible with phase quantization
    for col = 1:size(mask_rect,2)
        mask_col = mask_rect(:,col);
        mask_code(:,2*col-1:2*col) = [mask_col mask_col];
    end
    % according to the number of parameters for the gabor wavelet, repeat
    % the mask
    ratio = iris_code_row_n/size(mask_rect,1);
    mask_rect = mask_code;
    for r = 1:ratio-1
        mask_code = [mask_code;mask_rect];
    end
end

