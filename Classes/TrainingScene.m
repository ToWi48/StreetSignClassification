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
            td.image        = NaN;
            td.velocity     = strrep(extractedName{2}, "kmh", "");
            td.shape        = extractedName{3};
            td.background   = extractedName{4};
            td.weather      = extractedName{5};
            td.id           = extractedName{6};
        end

        function td = load(td)
            [indexedImage, cmap] = imread(td.path);

            if length(cmap) > 1
                td.image = ind2rgb(indexedImage, cmap);
            else
                td.image = indexedImage;
            end

        end

        function td = unload(td)
            clear td.image
            td.image = NaN;
        end
    end
end