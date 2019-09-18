% __________________________EBCC_routine________________________
% � Aur�lie M. Stephan, University of Lausanne

% Routine to process data and create graphs for single subjects or whole groups for EBCC experiments (APRIL 2018)
% Last update: 12 July 2018

main_path = '/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/'; % path containing group data folders

routineProc = 'on';
while strcmp(routineProc,'on')
    
    %_________________MAIN MENU_____________________
    [procChoice,procChoiceStr] = prompt('Process EBCC responses of a single subject','Process EBCC responses of all subjects of a group',...
        'Process mean group response from already analyzed single subjects data','Plot EBCC recordings with or without detection', ...
        'Plot EBCC analysis (learning curve, detector and evaluator perf)','Test filters ','Process blink propensity','What do you want to do? (see choices above):   ');
    
    switch procChoice
        
        case 1 %_______Process MEP responses of a single subject
            
            [~,gp_ID] = prompt('HV','HVV','HVY','CRPS','FHD','CD','In what group is the subject you want to analyze (see choice above)?:   ');
            gp_ID=gp_ID{1,:};
            
            gp_folder=[main_path,gp_ID];
            cd(gp_folder)
            
            [~ , sub_ID] = listing(pwd,'dir',gp_ID, '*', 1,1);
            
            eyeChoice = prompt('Right Exe','Left Eye', 'What eye do you want to analyze?  ');
            
            [~,CRChoice] = prompt('550','600', 'What CR window start do you want to use for analysis?  ');
            CRChoice=CRChoice{1,:};
            CRChoice = str2double(CRChoice);
            
            thresh_rep = prompt('What threshold (as a multiplicator or a range of multiplicators of noise std) do you want to use ? : ');
            duration_rep = prompt('What minimum duration of resp in ms do you want to use ? usually 1 or between 10 and 50 : ');
            [~,~, fig_gen,raw_rep,marker_rep, pause_rep, save_rep] = prompt('Generate Figures','Generate also raw signal','Put markers for noise and timewin on non raw figures','Pause on figures', 'Save figures',...
                'What figures options do you want to use ? ');
            
            n_thresh = length(thresh_rep);
            n_dur = length(duration_rep);
            
            for thresh_count = 1 : n_thresh
                for dur_count = 1:n_dur
                    
                    curr_thresh = thresh_rep(thresh_count);
                    curr_dur = duration_rep(dur_count);
                    [All_rep_duration,All_start, nb_CR, All_peak, timeToOnset_cond, timeToPeak_cond] = ...
                        EBCC_process(gp_ID,sub_ID,eyeChoice,CRChoice,curr_thresh,curr_dur,fig_gen,raw_rep,marker_rep,pause_rep,save_rep);
                    
                    disp(['Finished ', num2str(curr_thresh), '* std - ', num2str(curr_dur), ' ms !']);
                    disp('------------------------------');
                end
                disp(['Finished all', num2str(curr_thresh), '* std - ', ' !']);
                disp('------------------------------');
            end
            
            
        case 2 %_______Process MEP responses of all subjects   of a group
            
            [~,gp_ID] = prompt('HV','HVV','HVY','CRPS','FHD','CD','In what group is the subject you want to analyze (see choice above)?:   ');
            gp_ID=gp_ID{1,:};
            
            gp_folder=[main_path,gp_ID];
            cd(gp_folder)
            
            [list_elements, file_name] = listing(pwd,'dir',gp_ID, '*', 0,0);
            n_subjects = length(list_elements);
            
            eyeChoice = prompt('Right Exe','Left Eye', 'What eye do you want to analyze?  ');
            
            [~,CRChoice] = prompt('550','600', 'What CR window start do you want to use for analysis?  ');
            CRChoice = str2double(CRChoice);
            
            thresh_rep = prompt('What threshold (as a multiplicator or a range of multiplicators of noise std) do you want to use ? : ');
            duration_rep = prompt('What minimum duration of resp in ms do you want to use ? usually 1 or between 10 and 50 : ');
            [~,~, fig_gen,raw_rep,marker_rep, pause_rep, save_rep] = prompt('Generate Figures','Generate also raw signal','Put markers for noise and timewin on non raw figures','Pause on figures', 'Save figures',...
                'What figures options do you want to use ? ');
            
            n_thresh = length(thresh_rep);
            n_dur = length(duration_rep);
            
            %___________________Process loop___________________
            for thresh_count = 1 : n_thresh
                for dur_count = 1:n_dur
                    for sub = 1:n_subjects
                        sub_ID = list_elements(sub).name;
                        disp(['Starting ', list_elements(sub).name, '...']);
                        
                        curr_thresh = thresh_rep(thresh_count);
                        curr_dur = duration_rep(dur_count);
                        [All_rep_duration, All_start, nb_CR, All_peak, timeToOnset_cond, timeToPeak_cond,all_CR] =...
                            EBCC_process(gp_ID,sub_ID,eyeChoice,CRChoice,curr_thresh,curr_dur,fig_gen,raw_rep,marker_rep,pause_rep, save_rep);
                        
                        disp(['Finished ', list_elements(sub).name, ' !']);
                        disp('------------------------------');
                        disp('------------------------------');
                    end
                    disp(['Finished ', num2str(curr_thresh), '* std - ', num2str(curr_dur), ' ms !']);
                    disp('------------------------------');
                    disp('------------------------------');
                end
                disp(['Finished all ', num2str(curr_thresh), '* std - ', ' !']);
                disp('------------------------------');
                disp('------------------------------');
                close all;
            end
            subChoice = 1;
            
        case 3 %___Process group response from already analyzed subjects data
            
            [~,gp_ID] = prompt('HV','HVV','HVY','CRPS','FHD','CD','In what group is the subject you want to analyze (see choice above)?:   ');
            gp_ID=gp_ID{1,:};
            
            gp_folder=[main_path,gp_ID];
            cd(gp_folder)
            
            eyeChoice = prompt('Right Exe','Left Eye', 'What eye do you want to analyze?  ');
            
            [~,CRChoice] = prompt('550','600', 'What CR window start do you want to use for analysis?  ');
            CRChoice = str2double(CRChoice);
            
            thresh_rep = prompt('What threshold (as a multiplicator or a range of multiplicators of noise std) do you want to use ? : ');
            duration_rep = prompt('What minimum duration of resp in ms do you want to use ? usually 1 or between 10 and 50 : ');
            
            n_thresh = length(thresh_rep);
            n_dur = length(duration_rep);
            cd(gp_folder);
            cd('detections');
            mkdir(date);
            
            % --- PROCESS ---
            for thresh_count = 1:n_thresh
                for dur_count = 1:n_dur
                    
                    curr_thresh = thresh_rep(thresh_count);
                    curr_dur = duration_rep(dur_count);
                    group_analysis_EBCC(gp_ID,eyeChoice,CRChoice,curr_thresh, curr_dur);
                    
                    disp(['Finished ', num2str(curr_thresh), '* std - ', num2str(curr_dur), ' ms !']);
                    disp('------------------------------');
                    disp('------------------------------');
                end
                disp(['Finished all ', num2str(curr_thresh), '* std - ', ' !']);
                disp('------------------------------');
                disp('------------------------------');
            end
            
        case 4 % Plot EBCC recordings
            plotChoice = prompt('Only one subject','All subject of a group','For whom do you want to plot EBCC recordings ?  ');
            [gp_choice,gp_ID] = prompt('HV','CRPS','FHD','CD','What group do you want to process (see choice above)?:   ');
            gp_ID=gp_ID{1,:};
            
            gp_folder=[main_path,gp_ID];
            cd(gp_folder);
            [list_elements , ~] = listing(pwd,'dir',gp_ID, '*', 0,0);
            n_subjects = length(list_elements);
            decision = prompt('Generate plots of raw recordings','Generate plots of detection with detection parameters of choice',...
                'What do you want to do? (See choice above):  ');
            %             if decision == 3
            %                         decision = [1 2];
            %             end
            saveChoice=input('Do you want to save the figures ? (y/n):   ','s');
            
            switch plotChoice
                
                case 1 % Plot raw
                    
                    [~ , sub_ID] = listing(pwd,'dir','', '*', 1,1);
                    plot_EBCC(gp_ID,sub_ID,decision,saveChoice,0,0);
                    
                case 2 % Plot detection
                    if decision == 2
                        thresh_choice = prompt('What threshold (as a multiplicator or a range of multiplicators of noise std) do you want to use ? : ');
                        duration_choice = prompt('What minimum duration of resp in ms do you want to use ? usually 1 or between 10 and 50 : ');
                    end
                    for sub = 2:n_subjects
                        sub_ID = list_elements(sub).name;
                        disp(['Starting ', sub_ID]);
                        plot_EBCC(gp_ID,sub_ID,decision,saveChoice,thresh_choice,duration_choice);
                    end
                    
                    
            end
            
        case 5
            EBCCdetect_analysis;
            
        case 6
            checkGap();
            
        case 7 % BLINK PROPENSITY
            
            [~,gp_ID] = prompt('HV','HVV','HVY','CRPS','FHD','CD','In what group is the subject you want to analyze (see choice above)?:   ');
            gp_ID=gp_ID{1,:};
            
            gp_folder=[main_path,gp_ID];
            cd(gp_folder)
            
            [list_elements, file_name] = listing(pwd,'dir',gp_ID, '*', 0,0);
            n_subjects = length(list_elements);
            
            eyeChoice = prompt('Right Exe','Left Eye', 'What eye do you want to analyze?  ');
            
            CRChoice = 1;
            thresh_rep=2.5;
            duration_rep = 25;
            
            [~,~, fig_gen,raw_rep,marker_rep, pause_rep, save_rep] = prompt('Generate Figures','Generate also raw signal','Put markers for noise and timewin on non raw figures','Pause on figures', 'Save figures',...
                'What figures options do you want to use ? ');
            
            n_thresh = length(thresh_rep);
            n_dur = length(duration_rep);
            
            nb_Blink_prop_GP=zeros(8,2,n_subjects);
            all_Blink_prop_GP=zeros(10,8,2,n_subjects);
            
            for sub = 1:n_subjects
                sub_ID = list_elements(sub).name;
                disp(['Starting ', list_elements(sub).name, '...']);
                
                curr_thresh = thresh_rep(1);
                curr_dur = duration_rep(1);
                
                % Process data_matrix and other input variables for Blink_propensity
                [xplotfilt,log_param, thresh_rep, duration_rep,marker_rep,save_rep,fig_gen,pause_rep,CRChoice]=...
                    EBCC_process_short(gp_ID,sub_ID, eyeChoice,CRChoice,thresh_rep, duration_rep, fig_gen, raw_rep, marker_rep,pause_rep, save_rep);
                
                [Blink_prop_duration, Blink_prop_start, Blink_prop_peak, nb_Blink_prop, all_Blink_prop] = Blink_propensity...
                    (xplotfilt,log_param, thresh_rep, duration_rep,marker_rep,save_rep,fig_gen,pause_rep,CRChoice);
                
                % Group variable creation
                all_Blink_prop_GP(:,:,:,sub)=all_Blink_prop;
                nb_Blink_prop_GP(:,:,sub)=nb_Blink_prop;
                
                main_path = '/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/';
                path_folder=[main_path,gp_ID,'/'];
                cd(path_folder)
                sub_folder = [path_folder, sub_ID];
                
                filename=[sub_ID,'- blinkProp -',' R - '];
                save(filename, 'nb_Blink_prop','all_Blink_prop');
                
                disp(['Finished ', list_elements(sub).name, ' !']);
                disp('------------------------------');
                disp('------------------------------');
            end
            
            % group data
            filename=[gp_ID,'- blinkProp -',' R - '];
            save(filename, 'nb_Blink_prop_GP','all_Blink_prop_GP');
            
    end
    
    continueRep=0;
    while continueRep ~= 1 && continueRep~= 2
        disp('1- Yes, pleaaase');
        disp('2- No more I beg you')
        continueRep=input('Do you want to do another processing / result illustration (see above)?   ');
        if continueRep == 1
            routineProc = 'on';
        else
            if continueRep == 2
                routineProc = 'off';
                disp('Thank you for using PhDLife Airline !');
            end
        end
    end
end
