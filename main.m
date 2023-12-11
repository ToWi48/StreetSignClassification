startup;

close all;
clear all;

disp("--------------------------------------------")
disp("---------- Start Image Validation ----------")
disp("--------------------------------------------")

TrainingPictures = TrainingPictureUtils.getPictures("TrainingPictures");
%TrainingPictures = TrainingPictureUtils.getPictures("TestPictures");
%TrainingPictures = TrainingPictureUtils.getPictures("TestPicturesSelected");

Run(TrainingPictures);