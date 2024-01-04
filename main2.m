data = load('source.mat');
x = data.t;
numSamples = 20000;
subsetSize = 5000; % Size of each subset
numSubsets = ceil(numSamples / subsetSize); % Number of subsets
subsets = cell(numSubsets, 1); % Initialize cell array for subsets

for k = 1:numSubsets
    startIdx = (k - 1) * subsetSize + 1;
    endIdx = k * subsetSize;
    subsets{k} = x(startIdx:endIdx);
    % Questions 2, 4
    for p = 7:5:12
        for i = 1:3
            [a_quantized, y, y_hat, y_hat_prediction] = dpcm_encoder(subsets{k}, p, i, min_value, max_value);

            figure
            title(['Subset ', num2str(k), ' - Prediction error and reconstructed signal for p=', num2str(p), ' and N=', num2str(i)]);
            %legend('x', 'y');
        
            subplot(3,1,1); % Create a subplot for signal y
            plot(y);
            xlabel('Prediction Error');

            subplot(3,1,2); % Create a subplot for signal x
            plot(subsets{k});
            xlabel('Initial Signal');

            x_reconstructed = dpcm_decoder(y_hat, p, a_quantized);

            subplot(3,1,3); % Create a subplot for signal x_recondtructed
            plot(x_reconstructed);
            xlabel('Reconstructed Signal');
        end
    end

    % Question 3
    % MSE matrix initialization
    mse_matrix = zeros(6, 3); 

    % Loop over each p and N value
    for p = 5:10
        for N = 1:3
            [~, ~, ~, y_hat_prediction] = dpcm_encoder(subsets{k}, p, N, min_value, max_value);
            currentMSE = mean((subsets{k} - y_hat_prediction).^2);  % Calculate current MSE
            mse_matrix(p - 4, N) = currentMSE;  % Assign to the matrix
        end
    end

    % Define a set of 6 distinct colors
    colors = [1, 0, 0; % Red
              0, 1, 0; % Green
              0, 0, 1; % Blue
              1, 1, 0; % Yellow
              1, 0, 1; % Magenta
              0, 1, 1]; % Cyan

    figure;
    hold on;

    % Loop over each p value
    for p = 5:10
        plot(1:3, mse_matrix(p - 4, :), 'Color', colors(p - 4, :), 'Marker', '.', 'MarkerSize', 15);
    end

    title('MSE (E[y^2]) for different values of p');
    xlabel('N (Quantization Bits)'); 
    xticks(1:3);
    ylabel('MSE');
    legend('p = 5', 'p = 6', 'p = 7', 'p = 8', 'p = 9', 'p = 10');

    hold off;
end




