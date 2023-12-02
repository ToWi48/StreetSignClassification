function boxed_image = StreetSignMask(image)
    % binarize and fill all objects
    [image_red_bin, ~] = createMask(image);
    image_red_filled = imfill(image_red_bin, 'holes');
    
    % get properties of circular objects
    objects = regionprops('table', image_red_filled, "Circularity", "FilledArea", "BoundingBox", "Image");
    objects = sortrows(objects, "FilledArea");
    
    idx = objects.FilledArea >= 500;
    objects = objects(idx,:);
    
    % get the first most matching objects
    NUM_MATCHING_OBJECTS = 10;
    if height(objects) < NUM_MATCHING_OBJECTS
        NUM_MATCHING_OBJECTS = height(objects);
    end
    filtered_objects = objects(end-NUM_MATCHING_OBJECTS+1:end, :);
    
    % get most round object
    diff_circularity = abs(filtered_objects(:, :).Circularity - 1);
    objects_circularity = table((1:height(filtered_objects))', filtered_objects(:, :).Circularity, diff_circularity, 'VariableNames', {'id', 'circularity', 'diff_circularity'});
    objects_circularity = sortrows(objects_circularity, "diff_circularity");
    object_of_choice_id = objects_circularity(1, :).id;
    
    mask        = filtered_objects(object_of_choice_id,:).Image{1};
    tmp_x       = floor(filtered_objects(object_of_choice_id, :).BoundingBox(1));
    tmp_y       = floor(filtered_objects(object_of_choice_id, :).BoundingBox(2));
    tmp_width   = width(mask) - 1;
    tmp_height  = height(mask) - 1;
    boxed_image = image(tmp_y:tmp_y+tmp_height, tmp_x:tmp_x+tmp_width, :);
    
    boxed_image = boxed_image .* uint8(mask);
end