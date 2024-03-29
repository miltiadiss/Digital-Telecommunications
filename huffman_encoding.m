% Read the PNG image
image = imread('parrot.png');

% Convert the image to a column vector
image_vector = image(:);

%First Order Source
% Find unique pixel values and their appearance probabilities
[unique_values, ~, pixel_counts] = unique(image_vector);
total_pixels = numel(image_vector);
appearance_probabilities = histcounts(image_vector, [unique_values; max(unique_values)+1]) / total_pixels;
disp('First Order Source Pixel Values and Appearance Probabilities:');
for i = 1:length(unique_values)
        % Concatenate the values and probabilities as a string
        result_string = strcat(num2str(unique_values(i)), ' , ', num2str(appearance_probabilities(i)));
        disp(result_string);
end

% Encode the first order image using Huffman coding
huffman_dict = huffmandict(unique_values, appearance_probabilities);
encoded_image = huffmanenco(image_vector, huffman_dict);
% Check if Huffman-encoded image is correct
decompressed_image_vector = huffmandeco(encoded_image, huffman_dict);
decompressed_image = reshape(decompressed_image_vector, size(image));
imshow(decompressed_image);
disp('Huffman Encoding:');
disp(huffman_dict);

% Calculate compression ratio J
j = numel(encoded_image) / numel(dec2bin(image_vector)); 
disp('Compression Ratio:');
disp(num2str(j));

% Calculate entropy
entropy = -dot(appearance_probabilities, log2(appearance_probabilities));
disp('Entropy of Huffman Encoding:');
disp(num2str(entropy));

% Calculate mean length of code
% Convert Huffman codes to double
huffman_codes_double = cellfun(@double, huffman_dict(:, 2), 'UniformOutput', false);
% Create a vector of lengths of Huffman codes
huffman_code_lengths = cellfun(@length, huffman_codes_double);
mean_length = dot(huffman_code_lengths, appearance_probabilities);
disp('Mean Length of Huffman Encoding:');
disp(num2str(mean_length));

% Calculate efficiency of code
efficiency = entropy / mean_length;
disp('Efficiency of Huffman Encoding:');
disp(num2str(efficiency));

%Binary Symmetrical Channel
% Calculate error probability (p) of BSC
received_sequence = binary_symmetric_channel(encoded_image);
differing_bits = sum(encoded_image ~= received_sequence); % Count the number of differing bits between the two sequences
p = differing_bits / length(encoded_image);
disp('Estimated Error Probability:');
fprintf('%.2f\n', p);

% Calculate capacity of BSC
% Calculate output entropy H(Y)
output_entropy = -p * log2(p) - (1 - p) * log2(1 - p);
bsc_capacity = 1 - output_entropy;
disp('BSC Capacity:');
disp(num2str(bsc_capacity));

% Calculate joint information
% Calculate conditional entropy H(Y|X)
p_x0 = sum(encoded_image == 0) / length(encoded_image);
p_x1 = 1 - p_x0;
p_y_given_x0 = sum(received_sequence(encoded_image == 0) == 0) / sum(encoded_image == 0);
p_y_given_x1 = sum(received_sequence(encoded_image == 1) == 1) / sum(encoded_image == 1);
conditional_entropy = - (p_x0 * p_y_given_x0 * log2(p_y_given_x0) + p_x1 * p_y_given_x1 * log2(p_y_given_x1));
joint_information = output_entropy - conditional_entropy;
disp('Joint Information:');
disp(num2str(joint_information));

% Second Order Source
% Initialize the map for pair counts
pairCounts = containers.Map('KeyType', 'char', 'ValueType', 'double');

% Get the dimensions of the image
[rows, cols] = size(image);

% Iterate over the image
for r = 1:rows
    for c = 1:(cols - 1) % Iterate until the second last column
        % Create the pair (current and next pixel)
        pair = [image(r, c), image(r, c + 1)];
        pairKey = sprintf('(%d,%d)', pair(1), pair(2));
        % Count the pairs
        if isKey(pairCounts, pairKey)
            pairCounts(pairKey) = pairCounts(pairKey) + 1;
        else
            pairCounts(pairKey) = 1;
        end
    end
end

% Calculate the total number of valid pairs
totalPairs = rows * (cols - 1);

% Calculate and display the probabilities
pairProbabilities = containers.Map('KeyType', 'char', 'ValueType', 'double');
pairKeys = keys(pairCounts);

for k = 1:length(pairKeys)
    key = pairKeys{k};
    pairProbabilities(key) = pairCounts(key) / totalPairs;
end

% Display the pairs and their probabilities
disp('Second Order Source Pixel Values and Appearance Probabilities:');
for k = 1:length(pairKeys)
    key = pairKeys{k};
    fprintf('%s: %.5f\n', key, pairProbabilities(key));
end

% Convert the pair keys to strings that can be used as symbols
pairKeys = keys(pairProbabilities);
symbols = 1:length(pairKeys);  % Assigning an index to each unique pair
probabilities = cell2mat(values(pairProbabilities));

% Encode the second order image using Huffman coding
[numericDict, avglen] = huffmandict(symbols, probabilities);

% Map the numeric symbols back to the pairs
pairDict = cell(size(numericDict, 1), 2);
for i = 1:size(numericDict, 1)
    pairDict(i, 1) = pairKeys(numericDict{i, 1});
    pairDict(i, 2) = numericDict(i, 2);
end

disp('Second Order Huffman Encoding:');
disp(pairDict);

% Calculate entropy
second_order_entropy = -dot(probabilities, log2(probabilities));
disp('Entropy of Second Order Huffman Encoding:');
disp(num2str(second_order_entropy));

% Calculate mean length of code
% Create a vector of lengths of Huffman codes
huffman_code_lengths = cellfun(@length, numericDict(:, 2));
second_order_mean_length = dot(huffman_code_lengths, probabilities);
disp('Mean Length of Second Order Huffman Encoding:');
disp(num2str(second_order_mean_length));

% Calculate efficiency of code
second_order_efficiency = second_order_entropy / second_order_mean_length;
disp('Efficiency of Second Order Huffman Encoding:');
disp(num2str(second_order_efficiency));
