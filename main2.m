data = load('source.mat');
x = data.t;
numSamples = 20000;
subsetSize = 5000; % Size of each subset
numSubsets = ceil(numSamples / subsetSize); % Number of subsets
subsets = cell(numSubsets, 1); % Initialize cell array for subsets

% Define the constants
min_value = -3.5;
max_value = 3.5;

for k = 1:numSubsets
    startIdx = (k - 1) * subsetSize + 1;
    endIdx = k * subsetSize;
    subsets{k} = x(startIdx:endIdx);
    % Question 2
    for p = 5:5:10
        for N = 1:3
            [~, ~, y, ~, ~] = dpcm_encoder(subsets{k}, p, N, min_value, max_value);

            figure;
            plot(subsets{k}, 'b');
            hold on;
            plot(y, 'r');
            hold off;
        
            title(['Subset ', num2str(k), ' - Prediction error and initial signal for p=', num2str(p), ' and N=', num2str(N)]);
            legend('Initial Signal', 'Prediction Error');
        end
    end

    % Question 3
    % MSE matrix initialization
    mse_matrix = zeros(6, 3); 

    % Loop over each p and N value
    for p = 5:10
        result_string = strcat(' p = ', num2str(p));
        disp(result_string);
        for N = 1:3
            [~, a, y, ~, ~] = dpcm_encoder(subsets{k}, p, N, min_value, max_value);
            disp(a);
            currentMSE = mean(y.^2);  % Calculate current MSE
            mse_matrix(p - 4, N) = currentMSE;  % Assign to the matrix
        end
    end

    % Define a set of colors
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

    % Question 4
    for p = 5:5:10
        for N = 1:3
            [a_quantized, ~, ~, y_hat, ~] = dpcm_encoder(subsets{k}, p, N, min_value, max_value);
            x_reconstructed = dpcm_decoder(y_hat, p, a_quantized);

            figure;
            subplot(2,1,1); 
            plot(subsets{k});
            title(['Reconstructed signal and initial signal for p=', num2str(p), ' and N=', num2str(N)]);
            xlabel('Initial Signal');

            subplot(2,1,2); 
            plot(x_reconstructed);
            xlabel('Reconstructed Signal');
        end
    end
end
