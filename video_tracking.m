% Open the video file
vidReader = VideoReader('test_data/ball.mp4');

% Read the first frame from the video
frame1_rgb = readFrame(vidReader);
if size(frame1_rgb, 3) == 1
    frame1_rgb = cat(3, frame1_rgb, frame1_rgb, frame1_rgb);
end
frame1_hsv = rgb2hsv(frame1_rgb);

% Let the user select the ROI interactively
figure; imshow(frame1_rgb);
title('Select the ROI and double-click inside the box');
rect = round(getrect);
x = rect(1) + rect(3)/2; 
y = rect(2) + rect(4)/2;
h = round(max(rect(3), rect(4))/2); 
close;

% Number of bins for Hue and Saturation
numBins = 6;

% Compute histogram from the initial ROI
hist_roi = compute_histogram(x, y, frame1_hsv, h, numBins);

% Initial position vector
y0 = [x, y];

% Create a video writer to save the output
outVid = VideoWriter('tracked_output.mp4', 'MPEG-4');
open(outVid);

% Display the initial ROI on the first frame
figure('Name', 'Tracking Results');
subplot(1,2,1);
imshow(insertShape(frame1_rgb, 'Rectangle', [x-h, y-h, 2*h, 2*h], 'Color', 'red', 'LineWidth', 2));
title('Initial ROI (Frame 1)');

% Process subsequent frames
frameIdx = 2;
while hasFrame(vidReader)
    disp("Frame " + frameIdx);
    % Read next frame
    frame_rgb = readFrame(vidReader);
    if size(frame_rgb,3) == 1
        frame_rgb = cat(3, frame_rgb, frame_rgb, frame_rgb);
    end
    frame_hsv = rgb2hsv(frame_rgb);

    % Compute the backprojection for the current frame
    backProj = calculate_backprojection(frame_hsv, hist_roi, numBins);

    % Apply mean shift to find the new position in the current frame
    epsilon = 0.5; % Convergence threshold
    try
        y0 = meanshift(frame_hsv, y0, hist_roi, h, epsilon, numBins);
    catch ME
        warning('Mean Shift failed at frame %d. Error: %s', frameIdx, ME.message);
        % If meanshift fails, we keep the old position
    end

    % Validate new coordinates
    if ~all(isfinite(y0)) || ...
        y0(1) <= 0 || y0(2) <= 0 || ...
        y0(1) > size(frame_rgb, 2) || y0(2) > size(frame_rgb, 1)
        % If invalid, we do not update the position
    end

    x_new = round(y0(1));
    y_new = round(y0(2));

    % Draw the tracked ROI on the current frame
    trackedFrame = insertShape(frame_rgb, 'Rectangle', [x_new-h, y_new-h, 2*h, 2*h], ...
                               'Color', 'red', 'LineWidth', 2);

    % Display the tracked frame
    subplot(1,2,2);
    imshow(trackedFrame);
    title(sprintf('Tracked ROI (Frame %d)', frameIdx));
    drawnow;

    % Write to output video
    writeVideo(outVid, trackedFrame);

    frameIdx = frameIdx + 1;
end

% Close the output video
close(outVid);