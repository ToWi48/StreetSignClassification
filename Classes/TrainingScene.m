classdef TrainingScene
    properties
        path
        image
        velocity
        shape
        background
        weather
        id
    end
    methods
        function td = TrainingScene(path)
            extractedPath = split(path, ".");
            extractedName = split(extractedPath{1}, "_");
            
            td.path         = path;
            td.image        = imread(path);
            td.velocity     = extractedName{2};
            td.shape        = extractedName{3};
            td.background   = extractedName{4};
            td.weather      = extractedName{5};
            td.id           = extractedName{6};
        end
    end
end