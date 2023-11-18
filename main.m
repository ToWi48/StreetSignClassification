startup;

close all;
clear all;

TrainingPictures = TrainingPictureUtils.getPictures("TrainingPictures");

for i = 1:length(TrainingPictures)
    scene = TrainingPictures(i);
    scene = scene.load();

    % Processing
    masked_image = StreetSignMask(scene.image);
    imshow(masked_image)
    pause(1)
    close all

    scene = scene.unload();
end
