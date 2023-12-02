function digit_images_filtered = StreetSignTodigits(resized_image)
    image_red = uint8(resized_image(:, :, 1) - 1/2 * (resized_image(:, :, 2) + resized_image(:, :, 3)));
    
    resized_image_hsv = rgb2hsv(resized_image);
    
    resized_image_hsv = imcomplement(resized_image_hsv(:,:,3));
    resized_image_hsv_bin = imbinarize(resized_image_hsv, 'global');
    
    resized_image_hsv_bin_size  = size(resized_image_hsv_bin);
    default_width               = uint16(2/3 * resized_image_hsv_bin_size(1));
    default_height              = uint16(2/3 * resized_image_hsv_bin_size(2));
    half_default_width          = uint16(1/2 * default_width);
    half_default_height         = uint16(1/2 * default_height);
    center_x                    = uint16(1/2 * resized_image_hsv_bin_size(1));
    center_y                    = uint16(1/2 * resized_image_hsv_bin_size(2));
    
    number_image = resized_image_hsv_bin(center_x-half_default_width:center_x+half_default_width, center_y-half_default_height:center_y+half_default_height, :);
    
    % extract single number
    digit_images = regionprops('table', number_image, "Circularity", "FilledArea", "BoundingBox", "Image");
    digit_images = sortrows(digit_images, "FilledArea");
    
    idx = digit_images.FilledArea >= 1/4 * max(digit_images.FilledArea);
    digit_images_filtered = digit_images(idx,:);
end