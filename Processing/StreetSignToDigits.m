function digit_images_filtered = StreetSignToDigits(image)
    image_hsv = rgb2hsv(image);
    
    image_hsv = imcomplement(image_hsv(:,:,3));
    image_hsv_bin = imbinarize(image_hsv, 'global');
    
    image_hsv_bin_size  = size(image_hsv_bin);
    default_width               = uint16(2/3 * image_hsv_bin_size(1));
    default_height              = uint16(2/3 * image_hsv_bin_size(2));
    half_default_width          = uint16(1/2 * default_width);
    half_default_height         = uint16(1/2 * default_height);
    center_x                    = uint16(1/2 * image_hsv_bin_size(1));
    center_y                    = uint16(1/2 * image_hsv_bin_size(2));
    
    number_image = image_hsv_bin(center_x-half_default_width:center_x+half_default_width, center_y-half_default_height:center_y+half_default_height, :);
    
    % extract single number
    digit_images = regionprops('table', number_image, "Circularity", "FilledArea", "BoundingBox", "Image");
    digit_images = sortrows(digit_images, "FilledArea");
    
    idx = digit_images.FilledArea >= 1/4 * max(digit_images.FilledArea);
    digit_images_filtered = digit_images(idx,:).Image;

    if height(digit_images_filtered) > 3
        digit_images_filtered = digit_images_filtered(1:3);
    end

    subplot(2, 4, 5); imshow(image);
    subplot(2, 4, 6); imshow(zeros(2,2));
    subplot(2, 4, 7); imshow(zeros(2,2));
    subplot(2, 4, 8); imshow(zeros(2,2));

    for i_plot = 1:height(digit_images_filtered)
        subplot(2, 4, 4+i_plot+1); imshow(digit_images_filtered{i_plot});
    end
    pause(0)
end