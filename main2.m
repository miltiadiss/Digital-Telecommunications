data = load('source.mat');
x = data.t;
numSamples = 20000;
subsetSize = 5000; % Size of each subset
numSubsets = ceil(numSamples / subsetSize); % Number of subsets
subsets = cell(numSubsets, 1); % Initialize cell array for subsets

% Define the constants
min_value = -3.5;
max_value = 3.5;

% Question 2
% Iterate through each combination of p and N
for p = 5:5:10
    for N = 1:3
        % Create a new figure for each combination of p and N
        figure;
        title = ['p=', num2str(p), ', N=', num2str(N)];
        sgtitle(title); % Super title for the figure

        for k = 1:numSubsets
            startIdx = (k - 1) * subsetSize + 1;
            endIdx = min(k * subsetSize, numSamples);
            subsets{k} = x(startIdx:endIdx);

            [~, ~, y, ~, ~] = dpcm_encoder(subsets{k}, p, N, min_value, max_value);

            subplot(1, numSubsets, k);
            plot((startIdx:endIdx), subsets{k}, 'b');
            hold on;
            plot((startIdx:endIdx), y, 'r');
            hold off;
        end
    end
end

% Question 3
mse_matrix = zeros(6, 3, numSubsets); 

% Calculate MSE for each subset
for k = 1:numSubsets
    startIdx = (k - 1) * subsetSize + 1;
    endIdx = min(k * subsetSize, numSamples);
    subsets{k} = x(startIdx:endIdx);
    for p = 5:10
        for N = 1:3
            [~, ~, y, ~, ~] = dpcm_encoder(subsets{k}, p, N, min_value, max_value);
            currentMSE = mean(y.^2);
            mse_matrix(p - 4, N, k) = currentMSE;
        end
    end
end

% Define a set of colors
colors = [1, 0, 0; % Red
          0, 1, 0; % Green
          0, 0, 1; % Blue
          1, 1, 0; % Yellow
          1, 0, 1; % Magenta
          0, 1, 1]; % Cyan

% Create one figure
figure;

% Loop over each subset
for k = 1:numSubsets
    subplot(1, numSubsets, k);
    hold on;
    
    % Plot MSE for each value of p
    for p = 5:10
        mse_values = mse_matrix(p - 4, :, k); % Extract MSE values for current p and subset
        plot(1:3, mse_values, 'Color', colors(p - 4, :), 'Marker', 'o', 'LineStyle', '-');
        % The 'LineStyle', '-' argument adds lines between points
    end
    
    hold off;
    xlabel('N (Quantization Bits)');
    ylabel('MSE');
    if k == 1
        legend(arrayfun(@(p) ['p = ' num2str(p)], 5:10, 'UniformOutput', false), 'Location', 'best');
    end
end

% Question 4
% Iterate through each value of p
for p = 5:5:10
    for N = 1:3
        figure;
        sgtitle(['p=', num2str(p), ', N=', num2str(N)]);

        for k = 1:numSubsets
            startIdx = (k - 1) * subsetSize + 1;
            endIdx = min(k * subsetSize, numSamples);
            subsets{k} = x(startIdx:endIdx);

            [a_quantized, ~, ~, y_hat, ~] = dpcm_encoder(subsets{k}, p, N, min_value, max_value);
            x_reconstructed = dpcm_decoder(y_hat, p, a_quantized);

            % Plot the initial signal for subset k
            subplot(2, numSubsets, k); 
            plot((startIdx:endIdx), subsets{k});

            % Plot the reconstructed signal for subset k
            subplot(2, numSubsets, k + numSubsets); 
            plot((startIdx:endIdx), x_reconstructed);
        end
    end
end
