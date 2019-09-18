function [All_rep_duration,All_start, nb_CR, All_peak, timeToOnset_cond, timeToPeak_cond, all_CR]= EBCC_process(gp_ID,sub_ID, eyeChoice,CRChoice,thresh_rep, duration_rep, fig_gen, raw_rep, marker_rep,pause_rep, save_rep)
% This script allows to:
% 1) Visualize raw recordings of eye muscle activity
% 2) Detect conditioned responses (CR) based on user defined parameters
% 3) Get a visual feedback of said CRs
% 4) Get a learning curve displaying the number of CR/block across 7 learning blocks
% 5) Check left (control) eye activity
% 6) Save processed data (duration of detected CRs, nb of CR/block)
%
% INPUTS:
% 1) gp_ID: data of single subject or several subjects of a same group can be found if the group ID is given, 
% it should be the same name as the group folder in which subjects data can be found
% 2) sub_ID: if single subject is to be processed, sub_ID should be the
% subject folder ID in which the data can be found
% 3) thresh_rep: should be a single value or a vector that will be used as
% a multiplier of baseline std and give the intensity threshold for a
% response in CR timewindow to be considered a CR
% 4) duration_rep: should be a single value or a vector that will be used
% as the minimum duration of a reponse in CR timewindow to be considered a CR
% 5) fig_gen: should be 1 if the user wants to generate any figures
% 6) raw_rep: should be 1 if the user wants to generate figures of the raw signal
% without any changes or processing of it, otherwise 0
% 7) marker_rep: should be 1 if the user wants markers indicating
% thresholds of detection and timewindows plotted on the figures, otherwise 
% 8) pause_rep: should be 1 if the user wants the script to pause at every
% generated figure to be able to observe it at will
% 9) save_rep: should be 1 if the user wants to save generated figures
% 
% Functions needed for the script to work :
% CR_detection, checkNload and homogenize_vector
%
% % ??? Aur???lie M. Stephan, University of Lausanne

main_path = '/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/';


%% INITIALIZATION

path_folder=[main_path,gp_ID,'/'];
cd(path_folder)
sub_folder = [path_folder, sub_ID];
cd(sub_folder)

if ~isdir(['/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/',gp_ID,'/',sub_ID,'/Figures'])
    mkdir('Figures'); % creates a figure folder in the sub folder for future processing
end
path_nguyet=[sub_folder,'/Nguyet_extract']; % sub folder containing data
cd(sub_folder)
if ~isdir(['/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/',gp_ID,'/',sub_ID,'/Data'])
    mkdir('Data'); % sub folder where to save processed data
end
MLdata_folder = [sub_folder, '/Data'];

%% LOADING LOG FILES

% COND
[log_cond_temp] = checkNload(sub_folder,'cond.log'); % checks existence of file and loads it in a structure
log_cond=log_cond_temp.data; % extract numerical data in a vector
cd(sub_folder);

% EXT
if ~exist('ext.log','file') % WHILE LOOP FOR COND.LOG IMPORT
    disp('The ext.log file does not exist, an empty file will be created instead');
    log_ext_temp = [6250 8750 2 20];
    ext_exist=0;
else
    [log_ext_temp] = checkNload(sub_folder,'ext.log');
    ext_exist=1;
end

if strcmp(class(log_ext_temp),'struct')==1
    log_ext=log_ext_temp.data;
else
    log_ext=log_ext_temp;
end
clear log_cond_temp
clear log_ext_temp


log_param=zeros(4,2); % rows: 1-rate, 2-pts, 3- nb muscles, 4- nb trials; col: 1- cond, 2-ext
% Putting all parameters in one same matrix to be able to get them in loops later
for i = 1:4 % loading parameters from conditioning in 1st col of log_param
    log_param(i,1)=log_cond(i);
end
for i = 1:4 % loading parameters from extinction in 2nd col of log_param
    log_param(i,2)=log_ext(i);
end

%% LOADING DATA
disp('Starting to load data');

cd(path_nguyet);
step_name={'Conditioning', 'Extinction'};
n_trial=log_param(4,:); %nb of trials in cond and ext
data_matrix=zeros(log_param(2,1),10,8,2,2); % data points, trials, blocks, muscles, step
if ext_exist == 1
    for step = 1:size(log_param,2) % loop for step (conditioning, extinction)
        if step == 1 % Enter in the right folder
            cd('Cond');
        else
            cd('Ext');
        end
        
        % Check if file exist and load into data matrix
        block =1;
        count_t=1;
        for trial = 1:n_trial(1,step) % each trial
            temp_data = checkNload(0,int2str(trial)); % checks existence of data file and loads it in temp - 8750 pts x 2 muscles
            % loads curr trial in matrix containing all trials, blocks and steps
            data_matrix(1:log_param(2,step),count_t,block,:,step)=temp_data(1:log_param(2,step),:);
            % I put 1:log_param(2,step) (which is 1: total nb of points) for
            % temp_data because, in a previous step with another software, if
            % the user mistakenly does twice the same trial, the same data will
            % be appended and so nb of points will be x 2
            count_t = count_t + 1;
            if count_t > 10 % to store 10 trials per block
                count_t=1;
                block=block+1;
            end
        end
        cd .. % go back to Nguyet_extract folder to be able to enter in 'Ext' folder in next step loop
    end
else
    cd('Cond');
    block =1;
    count_t=1;
    step=1;
    for trial = 1:n_trial(1,step) % each trial
        temp_data = checkNload(0,int2str(trial)); % checks existence of data file and loads it in temp - 8750 pts x 2 muscles
        % loads curr trial in matrix containing all trials, blocks and steps
        data_matrix(1:log_param(2,step),count_t,block,:,step)=temp_data(1:log_param(2,step),:);
        % I put 1:log_param(2,step) (which is 1: total nb of points) for
        % temp_data because, in a previous step with another software, if
        % the user mistakenly does twice the same trial, the same data will
        % be appended and so nb of points will be x 2
        count_t = count_t + 1;
        if count_t > 10 % to store 10 trials per block
            count_t=1;
            block=block+1;
        end
    end
    cd .. % go back to Nguyet_extract folder to be able to enter in 'Ext' folder in next step loop
end

% As the right eye is the main interest, most processes will be done on it - left_eye kept for control 
chosen_eye = squeeze(data_matrix(:,:,:,eyeChoice,:));
% left_eye = squeeze(data_matrix(:,:,:,2,:));

% Filtering
aqFreq = log_param(1,1);
normFq = [10,200]./ aqFreq;
b = fir1(20,normFq);
xplotfilt = filter(b,1,chosen_eye);
cd(sub_folder)
cd('Data');
save('filtered_data.mat','xplotfilt');

%% PLOT RAW SIGNAL (all trials per block)

if raw_rep == 1
    
    disp('Starting generation of raw signal plots')
    
    for step = 1:size(log_param,2) % loop for step (conditioning, extinction)
        duration_ms=log_param(2,step)/log_param(1,step)*1000; % points/rate = duration in ms
        pas=duration_ms/log_param(2,step); % step between 0 and duration so that the size of the time axis in ms is the same as the data matrix in timepoints
        time_axis=0:pas:duration_ms; % used as x axis in plots (to see ms instead of timepoints)
        time_axis(end)=''; % there was 8751 col instead of 8750
        ylim_def=[min(min(min(data_matrix(5050:end,:,:,1,step)))) max(max(max(data_matrix(5050:end,:,:,1,step))))]; % define ylim of plots according to biggest response in unconditioned blink
        
        for block = 1:n_trial(1,step)/10 % nb of blocks will be 8 for cond and 2 for ext (nb of trial /10)
            h=figure;
            count_plot = 1;
            for trial = 1:size(data_matrix,2) % each trial
                
                curr_data=xplotfilt(:,trial,block,step); % to make plot line more readable
                
                subplot(5,2,count_plot);
                plot(time_axis,curr_data,'k'); % EMG PLOT
                hold on;
                line([400 400],ylim_def,'Color','m'); % SOUND START LINE
                hold on;
                line([600 600],ylim_def,'Color','g'); % CR WINDOW START LINE
                hold on;
                line([800 800],ylim_def,'Color','g'); % CR WINDOW END LINE
                count_plot=count_plot+1;
                
                ylim(ylim_def)
                ylabel('\muV')
                set(gcf,'units','normalized','outerposition',[0 0 1 1]); % full screen 
                
                if trial == 1 % to write title only above first trial
                    title([step_name{step},' block ', int2str(block)])
                else
                    if trial == 9 || trial == 10 % to write x axis label only at the bottom of figure (under trial 9 and 10)
                        xlabel('time - ms');
                    end
                end
            end
            if pause_rep == 1
                pause; % To allow user to look at each block
            end
            if save_rep == 1 % if user chose to save figures
                filename = [step_name{step},'-Block',num2str(block)];
                print(h,filename,'-dpng','-r90');
            end
            close;
        end
        
    end
    
end

%% VISUAL FEEDBACK OF DETECTED CRS WITH DURATION AND RMS AMPLITUDE

disp('Starting CR detection')

%% with 550 alphawin
cd([sub_folder,'/Figures']); % go to figure folders in case of saving
baseChoice='reject';
[All_rep_duration, All_start, All_peak, nb_CR, all_CR,Rep_amp,Peak_amp] =CR_detection_WGapNThreshMod(xplotfilt,log_param, ...
    thresh_rep, duration_rep,marker_rep,save_rep,fig_gen,pause_rep,CRChoice,baseChoice);
cd ..

%% TIME TO ONSET + TIME TO PEAK
duration_ms=log_param(2,1)/log_param(1,1)*1000;

timeToOnset_cond=zeros(10,8,2);
timeToPeak_cond=zeros(10,8,2);

if ~isempty(All_start) % in case there is no responses detected
    % TIME TO ONSET
    timeToOnset = All_start * duration_ms / log_param(2,1);
%     timeToOnset_cond(1:size(timeToOnset,2),1:size(timeToOnset,3)) = squeeze(timeToOnset(:,:,1));
%     timeToOnset_cond(timeToOnset_cond>0)= timeToOnset_cond(timeToOnset_cond>0)+200;
%     timeToOnset_cond(timeToOnset_cond==0)= NaN;
    timeToOnset(timeToOnset==0)= NaN;
    mean_TTO_cond = nanmean(timeToOnset);
    std_TTO_cond = nanstd(timeToOnset);
    
    % TIME TO PEAK
    timeToPeak = (All_peak+All_start) * duration_ms / log_param(2,1);
%     timeToPeak_cond(1:size(timeToPeak,2),1:size(timeToPeak,3)) = squeeze(timeToPeak(:,:,1));
%     timeToPeak_cond(timeToPeak_cond>0)= timeToPeak_cond(timeToPeak_cond>0)+200;
    timeToPeak(timeToPeak==0)= NaN;
    mean_TTP_cond = nanmean(timeToPeak);
    std_TTP_cond = nanstd(timeToPeak);
else
    timeToOnset=zeros(10,8,2);
    timeToOnset(timeToOnset==0)= NaN;
    timeToPeak=zeros(10,8,2);
    timeToPeak(timeToPeak==0)= NaN;
end

%% SAVING NUMERICAL DATA

cd(sub_folder);
cd('Data');
str_thresh=num2str(thresh_rep);
str_thresh(2)='-';

if duration_rep==5
    durStr = ['0',num2str(duration_rep)];
else
    durStr = num2str(duration_rep);
end

if eyeChoice == 2
filename = [sub_ID,'-data-',str_thresh,' * std-',num2str(duration_rep), ' ms - L - ', num2str(CRChoice)];
else
    filename = [sub_ID,'-data-',str_thresh,' * std-',num2str(duration_rep), ' ms - R - ', num2str(CRChoice)];
end

if ~isempty(All_start) % in case there is no responses detected
%     save(filename, 'All_rep_duration','All_start', 'nb_CR', 'All_peak', 'all_CR','timeToOnset_cond', 'timeToPeak_cond');
    save(filename, 'All_rep_duration','All_start', 'nb_CR', 'All_peak', 'all_CR','timeToOnset', 'timeToPeak','Rep_amp','Peak_amp');
else
    save(filename, 'All_rep_duration','All_start', 'nb_CR', 'All_peak','all_CR','Rep_amp','Peak_amp');
end    
OK = '';
save OK






%%
% 
% cd([sub_folder,'/Figures']); % go to figure folders in case of saving
% % [All_rep_duration, All_start, All_peak, nb_CR, all_CR] = CR_detection(xplotfilt,log_param,thresh_rep,duration_rep,marker_rep,save_rep,fig_gen,pause_rep,600);
% [All_rep_duration, All_start, All_peak, nb_CR, all_CR] =CR_detection_WGapNThreshMod(xplotfilt,log_param, thresh_rep, duration_rep,marker_rep,save_rep,fig_gen,pause_rep,CRChoice);
% cd ..

% %% TIME TO ONSET + TIME TO PEAK
% duration_ms=log_param(2,1)/log_param(1,1)*1000;
% 
% timeToOnset_cond=zeros(10,8);
% timeToPeak_cond=zeros(10,8);
% 
% if ~isempty(All_start) % in case there is no responses detected
%     % TIME TO ONSET
%     timeToOnset = All_start * duration_ms / log_param(2,1);
%     timeToOnset_cond(1:size(timeToOnset,2),1:size(timeToOnset,3)) = squeeze(timeToOnset(1,:,:,1));
%     timeToOnset_cond(timeToOnset_cond>0)= timeToOnset_cond(timeToOnset_cond>0)+200;
%     timeToOnset_cond(timeToOnset_cond==0)= NaN;
%     mean_TTO_cond = nanmean(timeToOnset_cond);
%     std_TTO_cond = nanstd(timeToOnset_cond);
%     
%     % TIME TO PEAK
%     timeToPeak = (All_peak+All_start) * duration_ms / log_param(2,1);
%     timeToPeak_cond(1:size(timeToPeak,2),1:size(timeToPeak,3)) = squeeze(timeToPeak(1,:,:,1));
%     timeToPeak_cond(timeToPeak_cond>0)= timeToPeak_cond(timeToPeak_cond>0)+200;
%     timeToPeak_cond(timeToPeak_cond==0)= NaN;
%     mean_TTP_cond = nanmean(timeToPeak_cond);
%     std_TTP_cond = nanstd(timeToPeak_cond);
% else
%     timeToOnset_cond=zeros(10,8);
%     timeToOnset_cond(timeToOnset_cond==0)= NaN;
%     timeToPeak_cond=zeros(10,8);
%     timeToPeak_cond(timeToPeak_cond==0)= NaN;
% end
% 
% %% SAVING NUMERICAL DATA
% 
% cd(sub_folder);
% cd('Data');
% str_thresh=num2str(thresh_rep);
% str_thresh(2)='-';
% if eyeChoice == 2
% filename = [sub_ID,'-data-',str_thresh,' * std-',num2str(duration_rep), 'L - ms - 600'];
% else
%     filename = [sub_ID,'-data-',str_thresh,' * std-',num2str(duration_rep), 'R - ms - 600'];
% endif ~isempty(All_start) % in case there is no responses detected
%     save(filename, 'All_rep_duration','All_start', 'nb_CR', 'All_peak', 'all_CR','timeToOnset_cond', 'timeToPeak_cond');
% else
%     save(filename, 'All_rep_duration','All_start', 'nb_CR', 'All_peak','all_CR');
% end    
% OK = '';
% save OK






