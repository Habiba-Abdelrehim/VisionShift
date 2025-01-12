function p = compute_histogram(x0, y0, frame, h, num_bins)
    % x0, y0: Center coordinates of the ROI
    % h: Radius of the ROI
    % frame: image
    % num_bins: number of bins for the histogram

    p = zeros(num_bins, num_bins);
    for n = 1 : num_bins
        for m = 1 : num_bins
            for i = -h : h
                for j = -h : h
                    if x0 + i > 0 && y0 + j > 0 && x0 + i < width(frame) && y0 + j < height(frame)
                        [bin_index_h, bin_index_s] = get_bin_index(x0 + i, y0 + j, frame, num_bins);
                        p(n, m) = p(n, m) + k((i / h)^2 + (j / h)^2) * isequal([bin_index_h, bin_index_s], [n, m]);
                    end
                end
            end
        end
    end

    p = p / sum(p, 'all');
end