function [digits, info] = StreetSignToDigits(number_image)
    info = "";

    image_hsv_h = rgb2hsv(number_image);
    image_hsv = image_hsv_h(:,:,3);
    number_image_bin = image_hsv > (3/5 * max(image_hsv, [], "all")); 
    number_image_bin = bwareaopen(number_image_bin, 10);

    %% take care to have black borders on x-axis
    number_image_bin(:, width(number_image_bin) + 1, :) = 0;

    %% cut out borders & reduce empty space
    number_image_bin_sum_x = sum(number_image_bin, 1);

    % left
    last_value = true;
    for i = 1:length(number_image_bin_sum_x)
        is_not_empty_line = number_image_bin_sum_x(i) > 0;
        idx(i) = is_not_empty_line || (last_value && not(is_not_empty_line));
        last_value = is_not_empty_line;
    end

    number_image_bin_cutted = number_image_bin(:, idx');

    %% get digit regions
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

    %% plot
    subplot(2, 4, 5); imshow(number_image_bin_cutted);
    subplot(2, 4, 6); imshow(zeros(2,2));
    subplot(2, 4, 7); imshow(zeros(2,2));
    subplot(2, 4, 8); imshow(zeros(2,2));

    if isempty(digits) || (length(digits) > 3)
        info = "digit count not match any pattern!";
        return
    end

    for i_plot = 1:length(digits)
        subplot(2, 4, 4+i_plot+1); imshow(digits{i_plot});
    end
    pause(0);
end