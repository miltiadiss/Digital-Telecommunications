% Question 1
function [a_quantized, y, y_hat, y_hat_prediction] = dpcm_encoder(x, p, quantization_bits, quantization_min_value, quantization_max_value)
    N = length(x);
    r = zeros(p, 1);
    R = zeros(p, p);
    a_quantized = zeros(p, 1);
    
    % Create autocorrelation matrix R and autocorrelation vector r
    for i = 1:p
        for j = 1:p
            sum = 0;
            for n = p+1:N
                sum = sum + x(n - j) * x(n - i);
            end
            R(i, j) = sum * 1/(N - p);
        end
    end

    for k = 1:p
        sum = 0;
        for n = p+1:N
            sum = sum + x(n) * x(n - k);
        end
        r(k) = sum * 1/(N - p);
    end
       
    % Quantize coefficients a with N=8 bits and dynamic range [-2,2] 
    a = R\r;
    for i = 1:p
        a_quantized(i) = my_quantizer(a(i), 8, -2, 2);
    end
    
    % Initialize y(n), y_hat_prediction(n) and y_hat(n)
    y = zeros(N, 1);
    y_hat = zeros(N, 1);
    y_hat_prediction = 0; 
    mem = zeros(p, 1);

    % Calculate the next values from p+1 to N
    for i = 1:N
        % Calculate the error and quantize it
        y(i) = x(i) - y_hat_prediction;
        y_hat(i) = my_quantizer(y(i), quantization_bits, quantization_min_value, quantization_max_value);
        % Update the y_hat_prediction to include the quantized error (reconstruction)
        y_hat_prediction = y_hat_prediction + y_hat(i);
        % Calculate the prediction y_hat'(n) using previous p y_hat_prediction values
        mem = [y_hat_prediction; mem(1:p -1)];
        y_hat_prediction = a_quantized.' * mem;
    end
end
