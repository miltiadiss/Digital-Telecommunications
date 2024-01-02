data = load('source.mat');
x = data.t;

% Define the constants
min_value = -3.5;
max_value = 3.5;

% Questions 2, 4
for p = 5:5:10
    for i = 1:3
        [a_quantized, y, ~] = dpcm_encoder(x, p, i, min_value, max_value);

        figure
        title(['Prediction error and reconstructed signal for p=', num2str(p), ' and N=', num2str(i)]);
        %legend('x', 'y');
        
        subplot(3,1,1); % Create a subplot for signal y
        plot(y);
        xlabel('Prediction Error');

        subplot(3,1,2); % Create a subplot for signal x
        plot(x);
        xlabel('Initial Signal');

        x_reconstructed = dpcm_decoder(y_hat, p, a_quantized);

        subplot(3,1,3); % Create a subplot for signal x_recondtructed
        plot(x_reconstructed);
        xlabel('Reconstructed Signal');
    end
end

% Question 3
mse_matrix = zeros(6, 3); 

for p = 5:10
    for N = 1:3
        [~, ~, y_hat_prediction] = dpcm_encoder(x, p, N, min_value, max_value);
        currentMSE = mean((x - y_hat_prediction).^2);  % Calculate current MSE
        mse_matrix(p - 4, N) = currentMSE;  % Assign to the matrix
    end
    disp(a_quantized);
end

num_p = length((5:10));
num_N = length((1:3));
% Flatten the mseMatrix to a vector
all_mse = reshape(mse_matrix', [], 1);
% Prepare N values for plotting
all_N = repmat((1:3), 1, num_p);

figure
    plot(all_N, all_mse, '.', 'MarkerSize', 15);
    title(['MSE (E[y^2]) for different values of p']);
    xlabel('N (Quantization Bits)'); 
    ylabel('MSE');

    legend_str = arrayfun(@(p) sprintf('p = %d', p), (5:10), 'UniformOutput', false);
    legend(legend_str, 'Location', 'best');

    xticks((1:3));