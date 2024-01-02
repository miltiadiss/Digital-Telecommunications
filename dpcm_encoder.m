% Question 1
function [a_quantized, y, y_hat_prediction] = dpcm_encoder(x, p, quantization_bits, quantization_min_value, quantization_max_value)

    N = length(x);

    if p > N
        error('p must be less than or equal to the length of x');
    end

    r = zeros(p, 1);
    R = zeros(p, p);
    
    % Create autocorrelation matrix R and autocorrelation vector r
    for i = 1:p
        r(i) = 1/(N - p) * (x(p+1:N).' * x(p+1-i:N-i));
        for j = 1:p
            R(i, j) =  1/(N - p) * (x(p+1-j:N-j).' * x(p+1-i:N-i));
        end
    end
       
    % Quantize coefficients a with N=8 bits and dynamic range [-2,2] 
    a_quantized = my_quantizer(R\r, 8, -2, 2);

    % Initialize y(n) and y_hat(n) 
    y = zeros(N, 1);
    y_hat = zeros(N, 1);
    
    % Calculate the first p values 
    for i = 1:p
        y(i) = x(i);
        y_hat(i) = my_quantizer(y(i), quantization_bits, quantization_min_value, quantization_max_value);
    end

    % Calculate the next values from p+1 to N 
    for i = p+1:N
        % Calculate the prediction y_hat'(n)
        y_hat_prediction = a_quantized.' * y_hat(i-1:-1:i-p);
        
        % Calculate the error and quantize it
        y(i) = x(i) - y_hat_prediction;
        y_hat(i) = my_quantizer(y(i), quantization_bits, quantization_min_value, quantization_max_value);
    end
end
