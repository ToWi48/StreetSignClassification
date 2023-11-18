classdef TrainingPictureUtils
    methods(Static)
        function ret = getPictures(path)
            %ret = [];
            imagefiles = dir(strjoin([path '*.png'], "/"));      
            for i=1:length(imagefiles)
                currentfilename = imagefiles(i).name;
                ret(i) = TrainingScene(currentfilename);
            end

            if length(imagefiles) <= 0
                warning(["no useable images found in " path])
            end
        end
    end
end