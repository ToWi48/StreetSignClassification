function [boxed_image, info] = StreetSignMask(image)
    info = "";

    % binarize and fill all objects
    [image_red_bin, ~] = createMask(image);
    image_red_filled = imfill(image_red_bin, 'holes');
    
    % get properties of circular objects
    objects = regionprops('table', image_red_filled, "Circularity", "FilledArea", "BoundingBox", "Image");
    objects = sortrows(objects, "FilledArea", 'descend');
    
    % remove all objects with filled area < 20 pixel
    idx = objects.FilledArea >= 20;
    objects = objects(idx,:);

    % get the first most matching objects
    NUM_MATCHING_OBJECTS = 10;
    if height(objects) < NUM_MATCHING_OBJECTS
        NUM_MATCHING_OBJECTS = height(objects);
    end

    % return if object list is empty
    if height(objects) == 0
        info = "can´t detect any object!";
        boxed_image = zeros(2, 2);
        return
    end
    
    objects_filledArea = objects(1:NUM_MATCHING_OBJECTS, :);
    
    % get most round object
    diff_circularity = abs(objects_filledArea(:, :).Circularity - 1);
    objects_circularity = table((1:height(objects_filledArea))', objects_filledArea(:, :).Circularity, diff_circularity, 'VariableNames', {'id', 'circularity', 'diff_circularity'});
    %objects_circularity = sortrows(objects_circularity, "diff_circularity");

    filled = objects_filledArea(:,:).FilledArea ./ max(objects_filledArea(:,:).FilledArea);
    circ = 1 - objects_circularity(:,:).diff_circularity;

    objects_diff = (0.5 .* filled) + (circ);
    [~, object_of_choice_id] = max(objects_diff);
    
    % cut out object of choice
    mask        = objects_filledArea(object_of_choice_id,:).Image{1};
    tmp_x       = floor(objects_filledArea(object_of_choice_id, :).BoundingBox(1));
    tmp_y       = floor(objects_filledArea(object_of_choice_id, :).BoundingBox(2));
    tmp_width   = width(mask) - 1;
    tmp_height  = height(mask) - 1;
    boxed_image = image(tmp_y:tmp_y+tmp_height, tmp_x:tmp_x+tmp_width, :);
    
    boxed_image = boxed_image .* uint8(mask);
    
    subplot(2, 4, 1); imshow(image);
    subplot(2, 4, 2); imshow(image_red_bin);
    subplot(2, 4, 3); imshow(image_red_filled);
    subplot(2, 4, 4); imshow(boxed_image);
    pause(0)
end