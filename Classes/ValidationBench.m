classdef ValidationBench  
    properties
        matches
        missdetections
        errors
    end
    
    methods
        function obj = ValidationBench()
            obj.matches = 0;
            obj.missdetections = 0;
            obj.errors = 0;
        end
        
        function obj = publishNoDetection(obj, scene, number, info)
            if scene.isValid
                obj.errors = obj.errors + 1;
                disp(strjoin(["Error:" info "(detect:" number "orig:" scene.velocity ")" "(" scene.path ")"]));
                %assert(false);
            else
                disp(strjoin(["Detection: invalid picture!" "(" scene.path ")"]));
                obj.matches = obj.matches + 1;
            end
        end
        
        function obj = publishDetection(obj, scene, number, probability)
            match = (number == scene.velocity);
        
            if match
                disp(strjoin(["Successfull Detection: probability:" probability "(detect:" number "orig:" scene.velocity ")" "(" scene.path ")"]));
                obj.matches = obj.matches + 1;
            else
                warning(strjoin(["Missdetection: probability:" probability "(detect:" number "orig:" scene.velocity ")" "(" scene.path ")"]));
                obj.missdetections = obj.missdetections + 1;
            end
        end

        function obj = printResult(obj)
            NUM_OF_TRIES = obj.matches + obj.missdetections + obj.errors;
            disp("--------------------------------------------");
            disp(strjoin(["Final detection rate: " obj.matches / NUM_OF_TRIES * 100 "%"]));
            disp(strjoin(["Final missdetection rate: " obj.missdetections / NUM_OF_TRIES * 100 "%"]));
            disp(strjoin(["Final error rate: " obj.errors / NUM_OF_TRIES * 100 "%"]));
            disp("--------------------------------------------");
        end
    end
end

