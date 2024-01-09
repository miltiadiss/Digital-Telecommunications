data = load('source.mat');
x = data.t;

% Define the constants
min_value = -3.5;
max_value = 3.5;

% Question 2
for p = 5:5:10
    for N = 1:3
        [~, ~, y, ~, ~] = dpcm_encoder(x, p, N, min_value, max_value);

        figure;
        plot(x, 'b');
        hold on;
        plot(y, 'r');
        hold off;
        
        title(['Prediction error and initial signal for p=', num2str(p), ' and N=', num2str(N)]);
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
        [~, a, y, ~, ~] = dpcm_encoder(x, p, N, min_value, max_value);
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
        [a_quantized, ~, ~, y_hat, ~] = dpcm_encoder(x, p, N, min_value, max_value);
        x_reconstructed = dpcm_decoder(y_hat, p, a_quantized);

        figure;
        subplot(2,1,1); 
        plot(x);
        title(['Reconstructed signal and initial signal for p=', num2str(p), ' and N=', num2str(N)]);
        xlabel('Initial Signal');

        subplot(2,1,2); 
        plot(x_reconstructed);
        xlabel('Reconstructed Signal');
    end
end
