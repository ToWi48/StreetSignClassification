function resized_image = StreetSignScaling(boxed_image)
    resized_image_size = max(size(boxed_image));
    resized_image = imresize(boxed_image, [resized_image_size, resized_image_size]);
end