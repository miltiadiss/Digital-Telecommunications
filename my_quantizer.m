function [y_hat] = my_quantizer(y, N, min_value, max_value)

    % Quantization step
    delta = (max_value - min_value)/ 2^N;
    
    % Calculation of centers of quantization area
    centers = zeros(2^N, 1);
    centers(1) = max_value - delta/2;
    centers(2^N) = min_value + delta/2;
    for i = 2:2^N - 1
        centers(i) = centers(i - 1) - delta;
    end
    
    % Process each element in y
    % Limiting the dynamic range of the current element
    if y < min_value
        y = min_value;
    end

    if y > max_value
        y = max_value;
    end

    %Create quantized input signal
    for i = 1: 2^N
        if((y <= centers(i) + delta/2) && (y >= centers(i) - delta/2))
            y_hat = centers(i);
        end
    end
end
