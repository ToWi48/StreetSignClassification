function probability = matchPattern(x_curve, y_curve, peaks_x, peaks_y)
    %% prepare
    peaks_x = sortrows(peaks_x, 1);
    peaks_y = sortrows(peaks_y, 1);

    %% y - axis
    n_peaks_y = height(peaks_y);
    [values, locations] = findpeaks(y_curve, "NPeaks", n_peaks_y);
    locations_norm = locations ./ length(y_curve);
    
    probability_y = 0;
    for i_peak = 1:n_peaks_y
        if i_peak > length(values)
            return
        end

        diff_location   = abs(peaks_y(i_peak, 1) - locations_norm(i_peak));
        diff_value      = abs(peaks_y(i_peak, 2) - values(i_peak));

        probability_y = probability_y + (1-diff_location) + (1-diff_value);
    end
    probability_y = 1/(2*n_peaks_y) .* probability_y;

    %% x - axis
    n_peaks_x = height(peaks_x);
    [values, locations] = findpeaks(x_curve, "NPeaks", n_peaks_x);
    locations_norm = locations ./ length(x_curve);
    
    probability_x = 0;
    for i_peak = 1:n_peaks_x
        if i_peak > length(values)
            return
        end

        diff_location   = abs(peaks_x(i_peak, 1) - locations_norm(i_peak));
        diff_value      = abs(peaks_x(i_peak, 2) - values(i_peak));

        probability_x = probability_x + (1-diff_location) + (1-diff_value);
    end
    probability_x = 1/(2*n_peaks_x) .* probability_x;

    %% result
    probability = 1/2 * (probability_x + probability_y);
end