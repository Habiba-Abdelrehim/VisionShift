function backProj = calculate_backprojection(image, hist, numBins)
    % This function computes the backprojection.
    % The function assumes the image is grayscale
    % and the histogram is normalised

    % Inputs:
    %   image  - cell array {X, Y} 
    %   hist   - histogram of the target
    %   numBins - number of bins in hist

    % Output:
    %   backProj - Backprojected probability map for the input image

    image = double(image);

    [height, width, dim] = size(image);
    backProj = zeros(height, width);

    for i = 1:height
        for j = 1:width
            [bin_index_h, bin_index_s] = get_bin_index(j, i, image, numBins);

            if bin_index_h >= 1 && bin_index_h <= numBins && bin_index_s >= 1 && bin_index_s <= numBins
                backProj(i, j) = hist(bin_index_h, bin_index_s);
            end
        end
    end
end
