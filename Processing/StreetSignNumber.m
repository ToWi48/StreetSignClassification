function [number, probability] = StreetSignNumber(bw_image, figure_obj)
    %% prepare
    number = 0;
    probability = 0;

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
    probabilitys(1)     = matchPattern(bw_image, TEMPLATE_1);
    probabilitys(2)     = matchPattern(bw_image, TEMPLATE_2);
    probabilitys(3)     = matchPattern(bw_image, TEMPLATE_3);
    probabilitys(4)     = matchPattern(bw_image, TEMPLATE_4);
    probabilitys(5)     = matchPattern(bw_image, TEMPLATE_5);
    probabilitys(6)     = matchPattern(bw_image, TEMPLATE_6);
    probabilitys(7)     = matchPattern(bw_image, TEMPLATE_7);
    probabilitys(8)     = matchPattern(bw_image, TEMPLATE_8);
    probabilitys(9)     = matchPattern(bw_image, TEMPLATE_9);
    probabilitys(10)    = matchPattern(bw_image, TEMPLATE_0);

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
        return;
    end
    
    % return plot and values
    order = {'1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; '0'};

    bar(order, probabilitys .* 100, 'Parent', figure_obj);
    xlabel("Number", 'Parent', figure_obj);
    ylabel("Probability [%]", 'Parent', figure_obj);

    number = tries(idx, :).id;
    probability = probabilitys(number);

    if number == 10
        number = 0;
    end
end