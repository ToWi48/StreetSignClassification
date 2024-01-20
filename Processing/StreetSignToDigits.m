function [digits, info] = StreetSignToDigits(number_image, figure_obj)
    %% prepare
    info = "";

    n_plots = 4;
    for i_plot = 1:n_plots
        plots(i_plot) = subplot(1, n_plots, i_plot, 'Parent', figure_obj);
    end

    %% processing
    image_hsv_h = rgb2hsv(number_image);
    image_hsv = image_hsv_h(:,:,3);
    number_image_bin = image_hsv > (3/5 * max(image_hsv, [], "all")); 
    number_image_bin = bwareaopen(number_image_bin, 10);

    imwrite(image_hsv,"BELEG/ProcessingToDigitsHSV.png")
    imwrite(number_image_bin,"BELEG/ProcessingToDigitsHSVBin.png")

    % take care to have black borders on x-axis
    number_image_bin(:, width(number_image_bin) + 1, :) = 0;

    % cut out borders & reduce empty space
    number_image_bin_sum_x = sum(number_image_bin, 1);

    % left
    last_value = true;
    for i = 1:length(number_image_bin_sum_x)
        is_not_empty_line = number_image_bin_sum_x(i) > 0;
        idx(i) = is_not_empty_line || (last_value && not(is_not_empty_line));
        last_value = is_not_empty_line;
    end

    number_image_bin_cutted = number_image_bin(:, idx');
    imwrite(number_image_bin_cutted,"BELEG/ProcessingToDigitsHSVBinSpaced.png")

    % get digit regions
    digit_borders = find(sum(number_image_bin_cutted, 1) == 0);
    
    digits = [];
    i_digit = 1;
    for i = 1:length(digit_borders)-1
        image = number_image_bin_cutted(:, digit_borders(i):digit_borders(i+1));
        if sum(image, "all") <= 1
            continue
        end
        image_sum_y = sum(image, 2);
        idy = image_sum_y > 0;
        idx = 2:width(image)-1;
        image = image(idy, idx');
        digits{i_digit} = image;
        i_digit = i_digit + 1;
    end

    %% plot and return
    imshow(number_image_bin_cutted, 'Parent', plots(1));    title("Resized", 'Parent', plots(1));
    imwrite(number_image_bin_cutted,"BELEG/ProcessingDigitsCutted.png")

    for i_plot = 2:n_plots
        imshow(zeros(2,2), 'Parent', plots(i_plot));        title("no digit", 'Parent', plots(i_plot));
    end

    if isempty(digits) || (length(digits) > 3)
        info = "digit count not match any pattern!";
        return
    end

    for i_plot = 1:length(digits)
        imshow(digits{i_plot}, 'Parent', plots(i_plot+1));  title(i_plot + ". Digit", 'Parent', plots(i_plot+1));
        imwrite(digits{i_plot},"BELEG/ProcessingDigitsCutted" + i_plot + ".png")
    end
    pause(0);
end