startup;

close all;
clear all;

USE_GUI = true;

disp("--------------------------------------------")
disp("---------- Start Image Validation ----------")
disp("--------------------------------------------")

if USE_GUI
    GUI;
else
    TrainingPictures = TrainingPictureUtils.getPictures("TrainingPictures");
    %TrainingPictures = TrainingPictureUtils.getPictures("TestPictures");
    %TrainingPictures = TrainingPictureUtils.getPictures("TestPicturesSelected");
    
    Run(TrainingPictures);
end