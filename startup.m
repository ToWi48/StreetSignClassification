[~, name, ~] = fileparts(pwd);
if name ~= 'StreetSignClassification'
    error("You´re not in the root directory! Please change!");
end

addpath("TrainingPictures");
addpath("TestPictures");
addpath("TestPicturesSelected");
addpath("Utils");
addpath("Classes");
addpath("Templates");
addpath("Processing");