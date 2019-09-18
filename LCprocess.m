function [LC, meanLC, stdLC] = LCprocess(gp_ID,file_ID,eyeID,CRWin,stepChoice)

cd(gp_ID)
cd('detections');
[datadir_list] = checkDate(pwd, 'new', 'dir','','*',0,0);
cd(datadir_list.name);
file_ID(6:6+length(gp_ID)-1)=gp_ID;
file_ID(end-4:end)=[];
file_ID(end+1:end+6)=['_ ',eyeID,' - '];
file_ID(end+1:end+7)=[num2str(CRWin),'.mat'];
load(file_ID); % 8, 2, 10, 2
LC = squeeze(nb_CR_GP(:,stepChoice,:,2))*10;
nsubHV=size(LC,2);
meanLC = mean(LC,2);
for block = 1:size(LC,1)
    stdLC(block) = std(LC(block,:))/sqrt(nsubHV);
end

cd ..


