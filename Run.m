function Run(app, TrainingPictures)
    % Start Testbench
    vb = ValidationBench();
    
    % foreach RoadSituation
    for i = 1:length(TrainingPictures)
        scene = TrainingPictures(i);
        scene = scene.load();

        app.FilenameLabel.Text = scene.path;

        number = 0;
        probability = 0;
    
        % Processing
        for i_tries = 1:3
            pause(app.PauseSpinner.Value);
            app.CurrentTrieValueLabel.FontColor = [0, 0, 0];
            app.ResultValueLabel.FontColor = [0, 0, 0];

            [masked_image, info]    = StreetSignMask(scene.image, i_tries, app.MaskPanel);
            
            if (info ~= "")
                continue
            end
        
            masked_image            = StreetSignScaling(masked_image);
            [digits, info]          = StreetSignToDigits(masked_image, app.DigitPanel);

            if isempty(digits)
                continue
            end
        
            [number, probability]   = StreetSignDigitsToNumber(digits, app.MatchPanel);
            app.CurrentTrieValueLabel.Text = num2str(number) + " km/h";

            [final_number, info]    = StreetSignNumberValidation(number, probability);
            
            if final_number == 0
                app.CurrentTrieValueLabel.FontColor = [1, 0, 0];
                vb = vb.publishNoDetection(scene, number, info);
                continue
            end
            
            vb = vb.publishDetection(scene, final_number, probability);
            app.ResultValueLabel.Text = num2str(final_number) + " km/h";

            if final_number == scene.velocity
                disp(strjoin(["found right image in trie" i_tries]));
                app.CurrentTrieValueLabel.FontColor = [0, 1, 0];
                app.ResultValueLabel.FontColor = [0, 1, 0];
            else
                app.CurrentTrieValueLabel.FontColor = [1, 0, 0];
                app.ResultValueLabel.FontColor = [1, 0, 0];
            end
            break
        end
    
        scene = scene.unload();
    end
    
    vb.printResult();
end