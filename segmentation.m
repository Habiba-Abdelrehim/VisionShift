image = imread('skin.jpg'); 
image = im2double(image); 
image = imresize(image, [50, 50]);  
[rows, cols, channels] = size(image);

spatial_bandwidth = 6;  % Kernel size for spatial features
color_bandwidth = 2;    % Kernel size for color features
max_iter = 2000;             % Maximum iterations for convergence
tol = 1e-3;               % Convergence tolerance

[X, Y] = meshgrid(1:cols, 1:rows);
features = cat(3, image, X / cols, Y / rows); % Combine color and spatial features
feature_vectors = reshape(features, [], channels + 2); % Flatten features (N x d)
num_points = size(feature_vectors, 1);

final_positions = zeros(num_points, channels + 2);

h_color = color_bandwidth;
h_spatial = spatial_bandwidth;

for i = 1:num_points
    % Current feature vector (pixel)
    x = feature_vectors(i, :);
    
    for iter = 1:max_iter
        % Compute differences in feature space
        distances = feature_vectors - x;
        distances(:, 1:channels) = distances(:, 1:channels) / h_color; % Normalize color
        distances(:, channels + 1:end) = distances(:, channels + 1:end) / h_spatial; % Normalize spatial
        
        % Compute Gaussian weights
        squared_distances = sum(distances.^2, 2); 
        weights = exp(-0.5 * squared_distances); % Gaussian kernel
        
        % Update weighted mean
        numerator = sum(feature_vectors .* weights, 1); % Weighted sum of features
        denominator = sum(weights); % Sum of weights
        x_new = numerator / denominator; % New mean location
        
        % Check for convergence
        if norm(x_new - x) < tol
            break;
        end
        
        x = x_new;
    end
    
    final_positions(i, :) = x;
end

result_image = reshape(final_positions(:, 1:channels), rows, cols, channels);

% Find unique clusters
unique_clusters = unique(round(final_positions, 4), 'rows');
num_clusters = size(unique_clusters, 1);

% Generate random colors for each cluster
random_colors = rand(num_clusters, channels); 

clustered_image = zeros(rows, cols, channels);

for i = 1:num_clusters
    % Find pixels belonging to the current cluster
    cluster_indices = ismember(round(final_positions, 4), unique_clusters(i, :), 'rows');
    
    clustered_image(repmat(cluster_indices, 1, 1, channels)) = repmat(random_colors(i, :), sum(cluster_indices), 1);
end

figure;
subplot(1, 2, 1); imshow(image); title('Original Image');
subplot(1, 2, 2); imshow(clustered_image); title('Clustered Image');
