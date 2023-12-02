function [number, info] = StreetSignNumberValidation(number, probability)
    %% Constants
    MIN_NUMBER_PROPABILITY = 0.7;
    VALID_STREET_VELOCITYS = [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130];

    %% Main
    % check min probability
    if probability < MIN_NUMBER_PROPABILITY
        number = 0;
        info = "minimum probability not reached - failed detection!";
        return
    end

    % check if number is valid
    if not(ismember(number, VALID_STREET_VELOCITYS))
        number = 0;
        info = "number is not part of the defined speed limits - failed detection!";
        return
    end

    number = number;
    info = "";
end