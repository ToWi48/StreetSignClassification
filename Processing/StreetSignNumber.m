function [number, probability] = StreetSignNumber(bw_image, figure)
    %% prepare
    n_plots_x = 11;
    n_plots_y = 2;
    for i_plot = 1:2*n_plots_x
        plots(i_plot) = subplot(n_plots_y, n_plots_x, i_plot, 'Parent', figure);
    end

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

    %% main
    %
    MIN_WIDTH   = 10;
    MIN_HEIGHT  = 10;

    % first check - envelope curve
    probabilitys        = [];
    probabilitys(1)     = matchPattern(bw_image, TEMPLATE_1, plots(2), plots(12));
    probabilitys(2)     = matchPattern(bw_image, TEMPLATE_2, plots(3), plots(13));
    probabilitys(3)     = matchPattern(bw_image, TEMPLATE_3, plots(4), plots(14));
    probabilitys(4)     = matchPattern(bw_image, TEMPLATE_4, plots(5), plots(15));
    probabilitys(5)     = matchPattern(bw_image, TEMPLATE_5, plots(6), plots(16));
    probabilitys(6)     = matchPattern(bw_image, TEMPLATE_6, plots(7), plots(17));
    probabilitys(7)     = matchPattern(bw_image, TEMPLATE_7, plots(8), plots(18));
    probabilitys(8)     = matchPattern(bw_image, TEMPLATE_8, plots(9), plots(19));
    probabilitys(9)     = matchPattern(bw_image, TEMPLATE_9, plots(10), plots(20));
    probabilitys(10)    = matchPattern(bw_image, TEMPLATE_0, plots(1), plots(11));

    tries               = table((1:length(probabilitys))', probabilitys', 'VariableNames', {'id', 'probability'});
    tries               = sortrows(tries, "probability", "descend");

    idx                 = 0;
    
    % second check - number of holes
    NUM_HOLES_IN_NUMBERS = [0, 0, 0, 0, 0, 1, 0, 2, 1, 1];

    euler_num = regionprops(bw_image, "Eulernumber");
    numHoles = 1 - euler_num(1).EulerNumber;

    % result
    for i_tries = 1:height(tries)
        i = tries(i_tries, :).id;
        if NUM_HOLES_IN_NUMBERS(i) == numHoles
            idx = i_tries;
            break
        end
    end

    if idx == 0
        number = 0;
        probability = 0;
        return;
    end
    
    number = tries(idx, :).id;
    probability = probabilitys(number);

    if number == 10
        number = 0;
    end
end