startup;

close all;
clear all;

disp("--------------------------------------------")
disp("---------- Start Image Validation ----------")
disp("--------------------------------------------")

TrainingPictures = TrainingPictureUtils.getPictures("TrainingPictures");
%TrainingPictures = TrainingPictureUtils.getPictures("TestPictures");
%TrainingPictures = TrainingPictureUtils.getPictures("TestPicturesSelected");

% Start Testbench
vb = ValidationBench();

figure;

% foreach RoadSituation
for i = 1:length(TrainingPictures)
    scene = TrainingPictures(i);
    scene = scene.load();

    number = 0;
    probability = 0;

    % Processing
    for i_tries = 1:3
        [masked_image, info]    = StreetSignMask(scene.image, i_tries);
        if (info ~= "")
            continue
        end
    
        masked_image            = StreetSignScaling(masked_image);
        
        [digits, info]          = StreetSignToDigits(masked_image);
        if isempty(digits)
            continue
        end
    
        [number, probability]   = StreetSignDigitsToNumber(digits);
        [final_number, info]    = StreetSignNumberValidation(number, probability);
        
        if final_number == 0
            vb = vb.publishNoDetection(scene, info, number);
            continue
        end
    
        vb = vb.publishDetection(scene, final_number, probability);

        if final_number == scene.velocity
            disp(strjoin(["found right image in trie" i_tries]));
        end
        break
    end

    scene = scene.unload();
end

vb.printResult();