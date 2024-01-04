% Question 1
function [a_quantized, y, y_hat, y_hat_prediction] = dpcm_encoder(x, p, quantization_bits, quantization_min_value, quantization_max_value)
    N = length(x);

    if p > N
        error('p must be less than or equal to the length of x');
    end

    r = zeros(p, 1);
    R = zeros(p, p);
    
    % Create autocorrelation matrix R and autocorrelation vector r
    for i = 1:p
        for j = 1:p
            for n = max(i, j):N
                R(i, j) = R(i, j) + x(n) * x(n - abs(i-j));
            end
        end
    end

    for k = 1:p
        for n = k+1:N
            r(k) = r(k) + x(n) * x(n - k);
        end
    end
       
    % Quantize coefficients a with N=8 bits and dynamic range [-2,2] 
    a = R\r;
    a_quantized = my_quantizer(a, 8, -2, 2);
    
    % Initialize y(n), y_hat_prediction(n) and y_hat(n)
    y = zeros(N, 1);
    y_hat = zeros(N, 1);
    y_hat_prediction = zeros(N, 1); 

    % Calculate the first p values
    for i = 1:p
        y_hat_prediction(i) = x(i); 
        % Calculate the error and quantize it
        y(i) = x(i) - y_hat_prediction(i);
        y_hat(i) = my_quantizer(y(i), quantization_bits, quantization_min_value, quantization_max_value);
    end

    % Calculate the next values from p+1 to N
    for i = p+1:N
        % Calculate the prediction y_hat'(n) using previous y_hat_prediction values
        y_hat_prediction(i) = a_quantized.' * y_hat_prediction(i-1:-1:i-p);
        % Calculate the error and quantize it
        y(i) = x(i) - y_hat_prediction(i);
        y_hat(i) = my_quantizer(y(i), quantization_bits, quantization_min_value, quantization_max_value);
        % Update the y_hat_prediction to include the quantized error (reconstruction)
        y_hat_prediction(i) = y_hat_prediction(i) + y_hat(i);
    end
end
