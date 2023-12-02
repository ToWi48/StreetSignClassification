startup;

close all;
clear all;

disp("--------------------------------------------")
disp("---------- Start Image Validation ----------")
disp("--------------------------------------------")

TrainingPictures = TrainingPictureUtils.getPictures("TrainingPictures");

matches = [];
errors = 0;

for i = 1:length(TrainingPictures)
    scene = TrainingPictures(i);
    scene = scene.load();

    % Processing
    masked_image            = StreetSignMask(scene.image);
    masked_image            = StreetSignScaling(masked_image);
    digits                  = StreetSignToDigits(masked_image);
    [number, probability]   = StreetSignDigitsToNumber(digits);
    [final_number, info]    = StreetSignNumberValidation(number, probability);

    if final_number == 0
        errors = errors + 1;
        disp(strjoin(["Error:" info "probability:" probability "(detect:" number "orig:" scene.velocity ")" "(" scene.path ")"]));
    else

        match = (final_number == str2num(scene.velocity));
    
        disp(strjoin(["Detection:" match "probability:" probability "(detect:" final_number "orig:" scene.velocity ")" "(" scene.path ")"]));
    
        matches(i) = match * 100;
        
        % figure
        % subplot(1,2,1); imshow(masked_image); title([num2str(number) " km/h"]);
        % pause(2);
        % close all
    end

    scene = scene.unload();
end

disp("--------------------------------------------");
disp(strjoin(["Final detection rate: " mean(matches) "%"]));
disp(strjoin(["Final error rate: " errors / length(TrainingPictures) .* 100 "%"]));
disp("--------------------------------------------");
