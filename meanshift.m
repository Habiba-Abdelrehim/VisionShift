function [y0] = meanshift(frame, y0, q, h, epsilon, num_bins)
    % frame: HSV image
    % y0: Initial guess for the center of density [x, y]
    % q: Target 2D histogram
    % h: Radius of the region of interest
    % epsilon: Convergence threshold
    % num_bins: the number of bins in the histogram


    [u, v] = meshgrid(1:width(frame), 1:height(frame));
    x_x = u(:);
    x_y = v(:);

    dist = inf;
    while dist > epsilon
        p_y0 = compute_histogram(y0(1), y0(2), frame, h, num_bins);

        % computing the weights
        w = zeros(length(x_x), 1);
        for i = 1 : length(x_x)
            [n, m] = get_bin_index(x_x(i), x_y(i), frame, num_bins);
            if p_y0(n, m) ~= 0
                w(i) = sqrt(q(n, m) / p_y0(n, m));
            end
        end

        y1_x = 0;
        y1_y = 0;
        d = 0;
        for i = 1 : length(x_x)
            norm_squared = ((y0(1) - x_x(i)) / h).^2 + ((y0(2) - x_y(i)) / h).^2;
            y1_x = y1_x + x_x(i)*w(i)*g(norm_squared);
            y1_y = y1_y + x_y(i)*w(i)*g(norm_squared);
            d = d + sum(w(i)*g(norm_squared));
        end
        y1_x = y1_x / d;
        y1_y = y1_y / d;

        y1 = [y1_x, y1_y];

        dist = norm(y1 - y0);
        y0 = y1;
        disp("  Meanshift distance: " + dist);
    end
end

