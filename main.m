startup;

close all;
clear all;

disp("--------------------------------------------")
disp("---------- Start Image Validation ----------")
disp("--------------------------------------------")

%TrainingPictures = TrainingPictureUtils.getPictures("TrainingPictures");
%TrainingPictures = TrainingPictureUtils.getPictures("TestPictures");
TrainingPictures = TrainingPictureUtils.getPictures("TestPicturesSelected");

vb = ValidationBench();

figure;

for i = 1:length(TrainingPictures)
    scene = TrainingPictures(i);
    scene = scene.load();

    number = 0;
    probability = 0;

    % Processing
    [masked_image, info]    = StreetSignMask(scene.image);
    if (info ~= "")
        vb = vb.publishNoDetection(scene, info, 0);
        continue
    end

    masked_image            = StreetSignScaling(masked_image);
    
    digits                  = StreetSignToDigits(masked_image);
    if isempty(digits)
        vb = vb.publishNoDetection(scene, "can´t find any digits!", 0);
        continue
    end

    [number, probability]   = StreetSignDigitsToNumber(digits);
    [final_number, info]    = StreetSignNumberValidation(number, probability);
    
    if final_number == 0
        vb = vb.publishNoDetection(scene, info, number);
        continue
    end

    vb = vb.publishDetection(scene, final_number, probability);

    scene = scene.unload();
end

vb.printResult();