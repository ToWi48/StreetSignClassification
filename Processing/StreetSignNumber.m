function [number, probability] = StreetSignNumber(bw_image)
    %% Number reference LUTs
    load("Templates\TEMPLATE_0.mat");
    load("Templates\TEMPLATE_1.mat");
    load("Templates\TEMPLATE_2.mat");
    load("Templates\TEMPLATE_3.mat");
    load("Templates\TEMPLATE_4.mat");
    load("Templates\TEMPLATE_5.mat");
    load("Templates\TEMPLATE_6.mat");
    load("Templates\TEMPLATE_7.mat");
    load("Templates\TEMPLATE_8.mat");
    load("Templates\TEMPLATE_9.mat");

    % peak      = [location, value]
    peaks_x_3   = [[0.23, 0.38]; [0.87, 1]];
    peaks_y_3   = [[0.9, 1]; [0.5, 0.5]; [0.1, 0.75]];

    %% Debug
    % bw_image = imbinarize(imread("DebugImages\CenterPixelBw.png"));
    % bw_image = bw_image(:,:,1);

    bw_image = TEMPLATE_8;

    %% main
    x_axis = sum(bw_image, 1);
    x_axis_norm = x_axis / max(x_axis);
    y_axis = sum(bw_image, 2);
    y_axis_norm = y_axis / max(y_axis);
    
    figure
    subplot(1, 4, 1); imshow(not(bw_image));
    subplot(1, 4, 2); barh(1:length(y_axis_norm), y_axis_norm); set(gca, 'YDir','reverse');
    subplot(1, 4, 3); plot(y_axis_norm(end:-1:1), 1:-1/length(y_axis_norm):1/length(y_axis_norm)); set(gca, 'YDir','reverse');
    subplot(1, 4, 4); plot(1/length(y_axis_norm):1/length(x_axis_norm):1, x_axis_norm);

    probability = matchPattern(x_axis_norm, y_axis_norm, peaks_x_3, peaks_y_3);

    number = 1;
    probability = 0;
end