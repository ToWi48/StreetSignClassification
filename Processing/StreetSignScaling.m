function resized_image = StreetSignScaling(boxed_image)
    resized_image_size = max(size(boxed_image));
    resized_image = imresize(boxed_image, [resized_image_size, resized_image_size]);
    imwrite(resized_image,"BELEG/ProcessingSkalingResized.png")

    % cutout rectangle
    image_size                  = size(resized_image);
    default_width               = uint16(2/3 * image_size(1));
    default_height              = uint16(2/3 * image_size(2));
    half_default_width          = uint16(1/2 * default_width);
    half_default_height         = uint16(1/2 * default_height);
    center_x                    = uint16(1/2 * image_size(1));
    center_y                    = uint16(1/2 * image_size(2));
    
    resized_image = resized_image(center_x-half_default_width:center_x+half_default_width, center_y-half_default_height:center_y+half_default_height, :);
    imwrite(resized_image,"BELEG/ProcessingSkalingBoxed.png")
end