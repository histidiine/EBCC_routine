function [All_rep_duration, All_start, All_peak, nb_CR, all_CR,Rep_amp,Peak_amp] =CR_detection_WGapNThreshMod(data_matrix,log_param,...
    thresh_choice, duration_choice,noise_rep,save_rep,fig_rep,pause_rep,CRwin_start,baseChoice)

% This function calculates the duration of CRs. You have the option to see
% or not a visual feedback of the detection algorithm by seeing ploted on the
% muscle response the start (green) and end (red) of each detected response
% (based on the defined threshold).
%
% � Aur�lie M. Stephan, University of Lausanne

step_name={'Conditioning', 'Extinction'};

% MANAGING CHOICES OF USER
if duration_choice <= 0 % if user enters 0 or negative value, default duration of 0.1 ms (complicated to make it none)
    duration_choice = 0.1;
    %     disp('Your choice of duration was invalid (0 or negative), it was thus changed to 0.1 ms')
end

nb_CR = zeros(size(data_matrix,3),size(data_matrix,4)); % nb of CR / block in both steps [bloks,steps]

if fig_rep == 1
    if save_rep == 1
        DateStamp=datestr(date);
        dir_name=[num2str(thresh_choice),'_',num2str(duration_choice),'ms_',DateStamp,'.mat'];
        mkdir(dir_name);
        cd(dir_name)
    end
end

all_CR = zeros(size(data_matrix,2),size(data_matrix,3),size(data_matrix,4));

% init
All_rep_duration = zeros(size(data_matrix,2),size(data_matrix,3),size(data_matrix,4));
All_start = zeros(size(data_matrix,2),size(data_matrix,3),size(data_matrix,4));
All_peak = zeros(size(data_matrix,2),size(data_matrix,3),size(data_matrix,4));
Rep_amp=zeros(size(data_matrix,2),size(data_matrix,3),size(data_matrix,4));

for step = 1:size(log_param,2) % loop for step (conditioning, extinction)
    
    % ___Time Axis___
    duration_ms=log_param(2,step)/log_param(1,step)*1000; % points/rate = duration in ms
    pas=duration_ms/log_param(2,step); % step between 0 and duration so that the size of the time axis in ms is the same as the data matrix in timepoints
    time_axis=0:pas:duration_ms; % used as x axis in plots (to see ms instead of timepoints)
    time_axis(end)=''; % there was 8751 col instead of 8750
    
    for block = 1:log_param(4,step)/10 % nb of blocks will be 8 for cond and 2 for ext (nb of trial /10)
        if fig_rep==1
            h=figure;
            count_plot=1;
        end
        for trial = 1:size(data_matrix,2) % each trial
            if block == 2 && trial == 8
                disp('');
            end
            
            % ------------ CURR DATA MATRICES ------------
            curr_data=data_matrix(:,trial,block,step); % to make plot line more readable
            noise_rms = rms(curr_data(1243:2493,:),1); % keep only 199 to 399 ms (noise)
            noise_std = std(curr_data(1243:2493,:),1);
            [yupper, ~] = envelope(curr_data,50); % envelope du signal (fq 300 pt)
            ylim_choice = [-0.2 0.2];
            
            % ------------ THRESHOLD & DURATION ------------
            threshold = thresh_choice * noise_std;
            startThresh = noise_std * (thresh_choice*0.85);
            thresh_minus = (thresh_choice-0.2) * noise_std;
            duration_choice_pt = duration_choice * log_param(2,step) /duration_ms; % convert in pt choice of minimum duration
            if CRwin_start == 550
                limStart = 220*log_param(2,step) /duration_ms;% 770 ms
                limEnd = 250*log_param(2,step) /duration_ms;
            else
                limStart = 170*log_param(2,step) /duration_ms;% 770 ms
                limEnd = 200*log_param(2,step) /duration_ms;
            end
            
            % ------------ DETECTOR ------------
            % Building detector:
            %             CRwin_start = 600;
            start_window = round(CRwin_start*log_param(2,step)/duration_ms);
            end_window = 4995;
            cr_timewindow=yupper(start_window:end_window,:); % 550 ms � 800
            detector = zeros(size(cr_timewindow)); % create a zeros matrix of the size of the cr window
            detector(cr_timewindow > startThresh) = 1; % whenever the signal is bigger than defined threshold replace 0 by 1
            diff_dec = diff(detector); % when passing fomr under to above thresh = 1, when passing from above to under -1, otherwise 0
            rep_start = find(diff_dec == 1); % all timepoints when passing above
            rep_end = find(diff_dec == -1); % all timepoints when passing under
            alphaStart = 0;
            if ~isempty(rep_end) && ~isempty(rep_start)
                if rep_end(1) < rep_start(1)
                    %                     rep_end(1) = []; % PROBLEM TO SOLVE: IT WILL IGNORE THERE WAS A MUSCLE RESPONSE THAT STARTED DURING ALPHA BLINK WINDOW
                    alpha_data = curr_data(start_window-937:start_window);
                    if round(rms(alpha_data),4)>round(threshold,4)
                        alphaStart = 1;
                    else 
                        rep_end(1)=[];
                    end
                end
            end
            if isempty(rep_end) & rep_start > limStart
                rep_end = limEnd;
            end
            % To avoid errors:
            if length(rep_start) > length(rep_end) % in case the cr timewindow finished while above threshold
                rep_end(end+1,1) = length(cr_timewindow);
            end
            
            % ----------_GAPS_------------
            setGap = 50; % 11ms
            
            % CREATE HERE LOOP TO REMOVE START AND REP WHO STARTED IN ALPHA
            % => ALPHASTART == 1
            if alphaStart == 1
                gap = 0;
                stillAlpha = 1;
                count = 1;
                while stillAlpha == 1 | (~isempty(rep_start)& ~isempty(rep_end))
                    gap=rep_start(1)-rep_end(1);
                    if gap < setGap
                        rep_start(1)=[];
                        rep_end(1)=[];
                    else
                        rep_end(1)=[];
                        stillAlpha = 0;
                    end
                    if isempty(rep_start) | isempty(rep_end)
                        break;
                    end
                end
                
            end
            
            gaps = 0; % to enter first time in while loop
            turn = 1;
            % MANAGED GAPS
            while ~isempty(find(gaps<setGap,1)) && turn < 40
                count=1;
                ind_end=[];
                gaps=[];
                for detect = 1 : length(rep_start)-1
                    gaps = rep_start(detect+1) - rep_end(detect);
                    if gaps < setGap
                        ind_end(count) = detect;
                        count=count+1;
                    end
                end
                turn = turn +1;
            end
            rep_end(ind_end)=[];
            rep_start(ind_end+1)=[];
            [rep_start, rep_end] = homogenize_vector(rep_start,rep_end,length(cr_timewindow));
            test_start=rep_start(2:end);
            gaps= test_start-rep_end(1:end-1);
            clear ind_end
            
            % ------------ UNDERLINE CR ACCORDING TO CHOSENT DURATION ---------------
            rep_duration = rep_end-rep_start;
            %             selected_rep=rep_duration(rep_duration>duration_choice_pt | rep_start > limStart);
            %             selected_start=rep_start(rep_duration>duration_choice_pt | rep_start > limStart);
            selected_rep=rep_duration;
            selected_start=rep_start;
            accepted_start=[];
            accepted_rep=[];
            selected_data=[];
            not_acc=[];
            hit =1; hit2=1;
            lateRepDur = 112.5; % = 18 ms
            if threshold < 0.01
                roundLvl = 4;
            else
                roundLvl = 3;
            end
            if ~isempty(rep_duration)
                for search = 1:length(selected_start)
                    if selected_rep(search) > duration_choice_pt || (rep_start(search) > limStart && selected_rep(search) > lateRepDur && block ~= 1)
                        tested_data = curr_data(start_window+selected_start(search):start_window+selected_start(search)+selected_rep(search),:);
                        lateRep = 0;
                        if round(rms(tested_data),roundLvl) >= round(threshold,roundLvl)
                            selected_data=tested_data(round(rms(tested_data),roundLvl) >= round(threshold,roundLvl));
                            accepted_start(hit)=selected_start(search);
                            accepted_rep(hit)=selected_rep(search);
                            hit=hit+1;
                            if ( start_window+selected_start(search)+selected_rep(search) ) >= end_window && block ~= 1  % in case resp is stoped by stim artifact
                                if selected_rep(search) > lateRepDur
                                    selected_data=tested_data(round(rms(tested_data),roundLvl) >= round(threshold,roundLvl));
                                    accepted_start(hit)=selected_start(search);
                                    accepted_rep(hit)=selected_rep(search);
                                    lateRep = 1;
                                end
                            end
                        else
                            if rms(tested_data)>thresh_minus && lateRep ~= 1
                                not_acc(hit2,1) = rms(tested_data);
                                not_acc(hit2,2) = selected_start(search);
                                not_acc(hit2,3) = selected_rep(search);
                                hit2=hit2+1;
                            end
                            
                        end
                    end
                end
            end
            
            [peak_amp ,rep_peak] = max(abs(selected_data));
            if ~isempty(accepted_rep)
                accepted_rep=accepted_rep(end);
                accepted_start=accepted_start(end);
                rep_peak=rep_peak(end);
                All_rep_duration(trial, block, step) = accepted_rep;
                %             All_start(1:length(accepted_start),trial, block, step)=accepted_start;
                All_start(trial, block, step)=accepted_start;
                %             All_peak(1:length(accepted_start),trial, block, step)=rep_peak;
                All_peak(trial, block, step)=rep_peak;
                % extract amplitude when a reponse is detected
                rms_data = rms(curr_data(start_window+accepted_start(1):start_window+accepted_start(1)+accepted_rep(1),:),1);
                if exist('rms_data','var')
                    Rep_amp(trial, block, step)=rms_data;
                end
                if exist('rep_peak','var')
                    Peak_amp(trial, block, step)=peak_amp;
                end
            end
                
            
            % ------------- SIGNAL AND ENVELOPE PLOT ---------------
            if fig_rep==1
%                 figure;
                subplot(5,2,count_plot);
                %                 plot(time_axis,abs(curr_data),'k'); % EMG PLOT
                plot(time_axis,curr_data,'k','LineWidth',1); % EMG PLOT
                hold on;
%                 pause;
                rep_start_ms = (start_window+accepted_start) * duration_ms / log_param(2,step); % (correct with start cr win)
                rep_duration_ms = accepted_rep * duration_ms / log_param(2,step);
                x_start = rep_start_ms ; % correcting since rep_start has an index based on CR window (600-800)
                x_dur = rep_duration_ms;
                size_bar = ylim_choice(2)/6;
                text_y = ylim_choice(1)/2;
                hold on;
                
                % --------- TEXT INFO ON PLOT ------- UPD 18 APR 2018
                descr_noise = ['Noise std: ', num2str(double(noise_std),2)];
                descr_noise2 = ['Threshold: ', num2str(double(threshold),2)];
                text(200,0.145,descr_noise);
                text(200,0.115,descr_noise2);
                
                if noise_rep == 1 % If user chose to get the markers on the figures (marker_rep in EBCC_routine and EBCC_process)
                    %                     line([0 1400], [threshold threshold],'linewidth',1,'Color','m');
                    if ~isempty(not_acc)
                        not_acc_text = 'did not pass:';
                        text(580,0.16,not_acc_text);
                        format short;
                        durMS = double(not_acc(:,3)) * duration_ms / log_param(2,step);
                        text(580,0.13,num2str(double(not_acc(:,1)),2));
                        text(580,0.10,[num2str(round(durMS),2),' ms']);
                        notacc_start = (start_window+not_acc(:,2)) * duration_ms / log_param(2,step); % (correct with start cr win)
                        notacc_dur = not_acc(:,3) * duration_ms / log_param(2,step);
                        line([notacc_start notacc_start+notacc_dur], [0.09 0.09],'Color','r','LineWidth',2); % blue underlying line
                    end
                end
                clear not_acc
                
                for detect = 1 : length(x_start)
                    show_start = x_start(detect); % extract each starting point of resp to where to start underlying line (x pos)
                    show_dur = x_start(detect)+x_dur(detect); % where to stop the underlying line
                    curr_y_pos = ylim_choice(1)/2+0.02;
                    line([show_start show_dur], [curr_y_pos curr_y_pos],'Color','b','LineWidth',2); % blue underlying line
                    rms_data = rms(curr_data(start_window+accepted_start(detect):start_window+accepted_start(detect)+accepted_rep(detect),:),1);
                    descr = [num2str(double(rms_data),2), ' �V '];
                    text(show_start,text_y,descr);
                end
                
                
                %------------- FIGURE PARAMETERS -------------
                hold on;
                line([CRwin_start CRwin_start],[ylim_choice(1) ylim_choice(2)],'Color','g');
                ylim(ylim_choice)
                ylabel('\muV')
                set(gcf,'units','normalized','outerposition',[0 0 1 1]); % full screen
                
                if trial == 1 % to write title only above first trial
                    title([step_name{step},' block ', int2str(block)])
                else
                    if trial == 9 || trial == 10 % to write x axis label only at the bottom of figure (under trial 9 and 10)
                        xlabel('time - ms');
                    end
                end
                count_plot=count_plot+1;
            end
            % Count nb of CR per block - even if more than one rep
            % are detected, only one per trial can be added
            if ~isempty(accepted_rep)
                nb_CR(block,step)= nb_CR(block,step)+1;
                all_CR(trial,block,step) = 1;
            end
        end
        % To allow user to look at each block
        if save_rep == 1
            filename = [step_name{step},'-Block',num2str(block),'-',num2str(CRwin_start)];
            print(h,filename,'-dpng','-r300');
        end
        if pause_rep == 1
            pause;
        end
        close;
    end
    
end
cd ..
end
