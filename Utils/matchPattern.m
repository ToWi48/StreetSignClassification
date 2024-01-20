function probability = matchPattern(orig_image, ref_image)
    % synch size
    ref_image = imresize(ref_image, size(orig_image));

    %% main
    x_axis_orig         = sum(orig_image, 1);
    y_axis_orig         = sum(orig_image, 2);
    x_axis_ref          = sum(ref_image, 1);
    y_axis_ref          = sum(ref_image, 2);

    x_axis_orig_norm    = x_axis_orig / max(x_axis_orig);
    y_axis_orig_norm    = y_axis_orig / max(y_axis_orig);
    x_axis_ref_norm     = x_axis_ref / max(x_axis_ref);
    y_axis_ref_norm     = y_axis_ref / max(y_axis_ref);
    
%    barh(1:length(y_axis_orig_norm), y_axis_orig_norm, 'Parent', figure_orig); set(gca, 'YDir','reverse');
    %barh(1:length(y_axis_ref_norm), y_axis_ref_norm, 'Parent', figure); set(gca, 'YDir','reverse');
    %plot(y_axis_ref_norm(end:-1:1), 1:-1/length(y_axis_ref_norm):1/length(y_axis_ref_norm)); set(gca, 'YDir','reverse', 'Parent', figure);

    % plot
    % figure
    % subplot(1, 4, 1); imshow(not(orig_image));
    % subplot(1, 4, 2); barh(1:length(y_axis_orig_norm), y_axis_orig_norm); set(gca, 'YDir','reverse');
    % subplot(1, 4, 3); plot(y_axis_orig_norm(end:-1:1), 1:-1/length(y_axis_orig_norm):1/length(y_axis_orig_norm)); set(gca, 'YDir','reverse');
    % subplot(1, 4, 4); plot(1/length(y_axis_orig_norm):1/length(x_axis_orig_norm):1, x_axis_orig_norm);

    % figure
    % subplot(1, 4, 1); imshow(not(ref_image));
    % subplot(1, 4, 2); barh(1:length(y_axis_ref_norm), y_axis_ref_norm); set(gca, 'YDir','reverse');
    % subplot(1, 4, 3); plot(y_axis_ref_norm(end:-1:1), 1:-1/length(y_axis_ref_norm):1/length(y_axis_ref_norm)); set(gca, 'YDir','reverse');
    % subplot(1, 4, 4); plot(1/length(y_axis_ref_norm):1/length(x_axis_ref_norm):1, x_axis_ref_norm);

    % process 
    diff_x = abs(x_axis_ref_norm - x_axis_orig_norm);
    diff_y = abs(y_axis_ref_norm - y_axis_orig_norm);

    diff = 0.5 * (mean(diff_x) + mean(diff_y));
    
    % result
    probability = 1 - diff;
end