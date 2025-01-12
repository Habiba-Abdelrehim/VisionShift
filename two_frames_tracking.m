% The ball
% % Load the image sequence
% im1 = imread("test_data/simple_color1.png");
% im2 = imread("test_data/simple_color2.png");
% im1_hsv = rgb2hsv(im1); 
% im2_hsv = rgb2hsv(im2);
% 
% % Define the initial Region of Interest in the first image
% x = 124; 
% y = 80; 
% h = 33;

% The car
% Load the image sequence
im1 = imread("test_data/car1.png");
im2 = imread("test_data/car2.png");
im1_hsv = rgb2hsv(im1); 
im2_hsv = rgb2hsv(im2);

% Define the initial Region of Interest in the first image
x = 478; 
y = 250; 
h = 40;

% Define bin edges for Hue and Saturation
numBins = 10; % Number of bins

% Compute the histogram of the ROI
hist_roi = compute_histogram(x, y, im1_hsv, h, numBins);

% Initialize the tracking position (center of the ROI)
y0 = [x, y];

% Compute backprojection for the second image
backProj = calculate_backprojection(im2_hsv, hist_roi, numBins);
imshow(backProj)

% Apply Mean Shift to find the new position in the second image
epsilon = 0.5; % Convergence threshold
y0 = meanshift(im2_hsv, y0, hist_roi, h, epsilon, numBins);

% Extract the new bounding box coordinates
x_new = round(y0(1));
y_new = round(y0(2));

% Draw ROI on the first image
im1_tracked = insertShape(im1, 'Rectangle', [x - h, y - h, 2 * h, 2 * h], 'Color', 'red', 'LineWidth', 5);

% Draw ROI on the second image
im2_tracked = insertShape(im2, 'Rectangle', [x_new - h, y_new - h, 2 * h, 2 * h], 'Color', 'red', 'LineWidth', 5);

figure;
subplot(1, 2, 1); imshow(im1_tracked); title('Initial ROI (Frame 1)');
subplot(1, 2, 2); imshow(im2_tracked); title('Tracked ROI (Frame 2)');

