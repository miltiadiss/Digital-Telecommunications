% Question 1
function [x_reconstructed] = dpcm_decoder(y_hat, p, a_quantized)
    N = length(y_hat);
    x_reconstructed = zeros(N, 1);

    % Calculate the first p values
    % This assumes that these values are directly transmitted without prediction.
    for i = 1:p
        x_reconstructed(i) = y_hat(i);
    end
    
    % Calculate the next values from p+1 to N
    for i = p+1:N
        % Calculate the prediction y_hat_prediction(n) using the quantized coefficients a_quantized
        % and the previously reconstructed values
        y_hat_prediction = a_quantized.' * x_reconstructed(i-1:-1:i-p);

        % Add the prediction to the quantized error to reconstruct x
        x_reconstructed(i) = y_hat_prediction + y_hat(i);
    end
end
