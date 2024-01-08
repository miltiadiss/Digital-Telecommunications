% Question 1
function [x_reconstructed] = dpcm_decoder(y_hat, p, a_quantized)
    N = length(y_hat);
    x_reconstructed = zeros(N, 1);
    mem = zeros(p, 1);
    y_hat_prediction = 0;

    % Calculate the next values from p+1 to N
    for i = 1:N
        % Add the prediction to the quantized error to reconstruct x
        x_reconstructed(i) = y_hat_prediction + y_hat(i);
        % Calculate the prediction y_hat_prediction(n) using the quantized coefficients a_quantized
        % and the previously reconstructed values
        mem = [x_reconstructed(i); mem(1:p - 1)];
        y_hat_prediction = a_quantized.' * mem;
    end
end
