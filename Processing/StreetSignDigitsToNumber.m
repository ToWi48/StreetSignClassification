function [number, probability] = StreetSignDigitsToNumber(digit_images, figure_obj)
    %% prepare
    info = "";

    n_plots = length(digit_images);
    for i_plot = 1:n_plots
        plots(i_plot) = subplot(1, n_plots, i_plot, 'Parent', figure_obj);
    end

    %% processing
    result_str = '';
    probabilitys = [];
    for i_digit = 1:length(digit_images)
        [number_res, probability] = StreetSignNumber(digit_images{i_digit}, plots(i_digit));
        probabilitys(i_digit) = probability;
        result_str = [result_str num2str(number_res)];
        title(i_digit + ". Digit", 'Parent', plots(i_digit));
    end
    number = str2num(result_str);
    probability = mean(probabilitys);
end