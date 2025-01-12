function [bin_index_hue, bin_index_saturation] = get_bin_index(x, y, frame, numBins)
    hue = frame(round(y), round(x), 1);
    saturation = frame(round(y), round(x), 2);

    min_val = 0;
    max_val = 1;

    bin_edges = linspace(min_val, max_val, numBins + 1);
    
    % Find the bin index for hue
    bin_index_hue = 0; 
    for i = 1:numBins
        if hue >= bin_edges(i) && hue < bin_edges(i + 1)
            bin_index_hue = i;
            break;
        end
    end
    
    if hue == max_val
        bin_index_hue = numBins;
    end

    % Find the bin index for saturation
    bin_index_saturation = 0; 
    for i = 1:numBins
        if saturation >= bin_edges(i) && saturation < bin_edges(i + 1)
            bin_index_saturation = i;
            break;
        end
    end
    
    if saturation == max_val
        bin_index_saturation = numBins;
    end
end