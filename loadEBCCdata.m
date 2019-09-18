function [all_CR_GP, nb_CR_GP, mean_CR_GP, std_CR_GP, TTO_GP, TTP_GP, all_Blink_prop_GP, nsub, func_pat, organic_pat, twstrs, had, gen_data, nb_CR_Func, nb_CR_Org,...
    mean_CR_func, mean_CR_org, nfunc, norg] = loadEBCCdata(gp_ID)

filepath=['/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/',gp_ID,'/detections/current'];
cd(filepath);
filename_CD=['EBCC_',gp_ID,'2-5 * std_25ms_ R - 550.mat'];
load(filename_CD);

nsub = size(nb_CR_GP,3);
short_CR_GP = squeeze(nb_CR_GP(:,1,:,1)); % [block,sub]
mean_CR_GP = mean(short_CR_GP,2);
hist_CR_GP = squeeze(nb_CR_GP(:,:,:,1));
std_CR_GP=std(short_CR_GP,0,2);

cd(['/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/',gp_ID]);
load([gp_ID,'- blinkProp - R - .mat']);


if strcmp(gp_ID,'CD')==1 % load clinical scores for patients
    
    data_folder='/Users/histidiine/AMS Drive/PhD/Thesis';
    cd(data_folder);
    func=xlsread('Classeur_CD_EBCC_study_AUG19.xlsx','Functional');
    func(10,:)=[];
    twstrs=xlsread('Classeur_CD_EBCC_study_AUG19.xlsx','TWSTRS');
    twstrs(10,:)=[];
    had=xlsread('Classeur_CD_EBCC_study_AUG19.xlsx','HAD');
    had(10,:)=[];
    gen_data=xlsread('Classeur_CD_EBCC_study_AUG19.xlsx','Summary');
    gen_data(10,:)=[];
    
    func = squeeze(func(:,4))';
    n_pat=length(func);
    
    threshold_func=2;
    
    func_pat=find(func>=threshold_func);
    nfunc=length(func_pat);
    organic_pat=find(func<threshold_func);
    norg=length(organic_pat);
    
    nb_CR_Func = squeeze(nb_CR_GP(:,:,func_pat,:));
    nb_CR_Org = squeeze(nb_CR_GP(:,:,organic_pat,:));
    
    short_CR_func = short_CR_GP(:,func_pat);
    mean_CR_func = mean(short_CR_func,2);
    short_CR_org = short_CR_GP(:,organic_pat);
    mean_CR_org = mean(short_CR_org,2);
    
end

end