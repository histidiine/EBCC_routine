function group_analysis_EBCC(gp_ID, eyeChoice,CRChoice, thresh_rep, duration_rep)

% NOTES
% This function takes the analyzed MEP amplitudes of processed subject with
% PAS_process_MAR2017 and creates a matrix of the amplitudes of all
% subjects of a same group and saves it in the group folder

% MUST ADD fid = fopen( 'report.txt', 'wt' );

main_path = '/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/';
gp_folder=[main_path,gp_ID];
cd(gp_folder);
[list_dir, ~] = listing(pwd,'dir',gp_ID, '*', 0,0);

n_subjects = length(list_dir);
cd(gp_folder);
cd('detections');
%% __________________GROUP MATRIX CREATION__________________
totalSub=1;
nb_CR_GP = zeros(8,2,n_subjects,2);
TTO_GP = zeros(10,8,2,n_subjects);
TTP_GP = zeros(10,8,2,n_subjects);
all_CR_GP = zeros(10,8,n_subjects,2);
Peak_Amp_GP=zeros(10,8,2,n_subjects);
for sub = 1:n_subjects
    cd(gp_folder)
    sub_ID = list_dir(sub).name;
    cd(sub_ID);
    cd('Data');
    if ~exist('OK.mat','file')
        disp([sub_ID, ' was not yet processed with EBCC_process_APR2018 and was thus ignored in this group calculation']);
    else
        str_thresh=num2str(thresh_rep);
        str_thresh(2)='-';
        
        if eyeChoice == 2
        mat_name = [sub_ID,'-data-',str_thresh,' * std-',num2str(duration_rep), ' ms - L - ', num2str(CRChoice),'.mat'];
        else
            mat_name = [sub_ID,'-data-',str_thresh,' * std-',num2str(duration_rep), ' ms - R - ', num2str(CRChoice),'.mat'];
        end
        if ~exist(mat_name,'file') 
            disp(['The script did not find the following file: ', mat_name]);
            disp('See list of file below and choose manually if you find it');
            disp('Otherwise enter 0 and this file will be ignored');
            [~, mat_name] = listing(pwd,'file',gp_ID, '*', 1,1);
        end
        if mat_name == 0 
            continue;
        else
            load(mat_name);
        end
        
        nb_CR_GP(:,:,totalSub,1)=nb_CR;
        all_CR_GP(1:size(all_CR,1),:,totalSub,1)=squeeze(all_CR(:,:,1));
        if exist('timeToOnset','var')
            TTO_GP(:,:,:,totalSub)=timeToOnset;
        end
        if exist('timeToPeak','var')
            TTP_GP(:,:,:,totalSub)=timeToPeak;
        end
        if exist('Rep_amp','var')
            CR_Amp_GP(:,:,:,totalSub)=Rep_amp;
        end
        if exist('Peak_amp','var')
            Peak_Amp_GP(1:size(Peak_amp,1),:,:,totalSub)=Peak_amp;
        end

%         alphawin = mat_name(end-6:end-4);
%         if strcmp(alphawin, '600')==1
%         
%         else
%             if strcmp(alphawin, '550')==1
%                
%             end
%         end
        
        totalSub = totalSub +1;
%         disp(['Just finished adding the data of ', sub_ID]);
        cd ..
    end
    clear timeToOnset timeToPeak
end
disp([int2str(totalSub-1), ' subjects were processed for this group calculation!']);

cd(gp_folder)
cd('detections');
cd(date);
str_thresh=num2str(thresh_rep);
str_thresh(2)='-';

if eyeChoice == 2
    save(['EBCC_',gp_ID,str_thresh,' * std_',num2str(duration_rep),'ms_ L - ', num2str(CRChoice),'.mat'],'nb_CR_GP', 'TTO_GP','TTP_GP','all_CR_GP','CR_Amp_GP','Peak_Amp_GP');
else
    save(['EBCC_',gp_ID,str_thresh,' * std_',num2str(duration_rep),'ms_ R - ', num2str(CRChoice),'.mat'],'nb_CR_GP', 'TTO_GP','TTP_GP','all_CR_GP','CR_Amp_GP','Peak_Amp_GP');
end



