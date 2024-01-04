function [y_hat] = my_quantizer(y, N, min_value, max_value)

    % Quantization step
    delta = (max_value - min_value) / (2^N - 1);

    % Calculation of centers of quantization area
    centers = min_value + delta/2 : delta : max_value - delta/2;

    % Pre-allocate y_hat
    y_hat = zeros(size(y));
    
    % Process each element in y
    for i = 1:length(y)
        % Limiting the dynamic range of the current element
        y_clipped = min(max(y(i), min_value), max_value);
        % Calculating the area to which the current element belongs
        [~, index] = min(abs(y_clipped - centers));
        % Mapping the current element to the center of the respective area
        y_hat(i) = centers(index);
    end
end
