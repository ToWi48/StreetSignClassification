function [boxed_image, info] = StreetSignMask(image, i_match, figure_obj)
    %% prepare
    info = "";
    
    n_plots = 4;
    for i_plot = 1:n_plots
        plots(i_plot) = subplot(1, n_plots, i_plot, 'Parent', figure_obj);
    end

    %% processing
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

    filled = objects_filledArea(:,:).FilledArea ./ max(objects_filledArea(:,:).FilledArea);
    circ = 1 - objects_circularity(:,:).diff_circularity;

    %object_prop = (0.5 .* filled) + (circ);
    object_prop = table((1:height(objects_circularity))', (0.5 .* filled) + (circ), 'VariableNames', {'id', 'object_prop'});
    object_prop = sortrows(object_prop, "object_prop", "descend");

    if i_match > height(object_prop.id)
        object_of_choice_id = height(object_prop.id);
    else
        object_of_choice_id = object_prop.id(i_match);
    end
    
    % cut out object of choice
    mask        = objects_filledArea(object_of_choice_id,:).Image{1};
    tmp_x       = floor(objects_filledArea(object_of_choice_id, :).BoundingBox(1));
    tmp_y       = floor(objects_filledArea(object_of_choice_id, :).BoundingBox(2));
    tmp_width   = width(mask) - 1;
    tmp_height  = height(mask) - 1;

    if tmp_width < 1 || tmp_height < 1
        info = "Object too small!";
        boxed_image = image;
        return
    end

    if tmp_x < 1
        tmp_x = 1;
    end

    if tmp_y < 1
        tmp_y = 1;
    end

    boxed_image = image(tmp_y:tmp_y+tmp_height, tmp_x:tmp_x+tmp_width, :);
    image_red_bin_1 = image_red_bin(tmp_y:tmp_y+tmp_height, tmp_x:tmp_x+tmp_width, :);
    
    boxed_image = imcomplement(boxed_image);
    boxed_image = boxed_image .* uint8(xor(mask, image_red_bin_1));

    %% plot and return
    imshow(image, 'Parent', plots(1));              title("Original", 'Parent', plots(1));
    imshow(image_red_bin, 'Parent', plots(2));      title("Binarized", 'Parent', plots(2));
    imshow(image_red_filled, 'Parent', plots(3));   title("Filled", 'Parent', plots(3));
    imshow(boxed_image, 'Parent', plots(4));        title("Result", 'Parent', plots(4));
    imwrite(image,"BELEG/ProcessingOrig.png")
    imwrite(image_red_bin,"BELEG/ProcessingMaskRed.png")
    imwrite(image_red_filled,"BELEG/ProcessingMaskRedFilled.png")
    imwrite(boxed_image,"BELEG/ProcessingMaskFinal.png")
end