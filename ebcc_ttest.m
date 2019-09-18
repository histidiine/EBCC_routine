function [ttest_results, indx_learners, indx_nonlearners] = ebcc_ttest(all_CR,taildef,n_trials_test)
% taildef = 'both', 'left' (x<y) or 'right' (x>y)

nsub = size(all_CR,3);
cat_CR = cat(1,squeeze(all_CR(:,1,:,1)),squeeze(all_CR(:,2,:,1)),squeeze(all_CR(:,3,:,1)),squeeze(all_CR(:,4,:,1)),...
    squeeze(all_CR(:,5,:,1)),squeeze(all_CR(:,6,:,1)),squeeze(all_CR(:,7,:,1)),squeeze(all_CR(:,8,:,1))); % cat blocks

for sub = 1:nsub
    x = squeeze(cat_CR(1:n_trials_test,sub));
    y = squeeze(cat_CR(end-n_trials_test+1:end,sub));
%     all_sub(1:length(x),sub)=x;
%     all_sub(length(x)+1:length(x)+length(y),sub)=y;
    [H,P,CI,STATS]=ttest(x,y,'tail',taildef);
    %     p_def = 0.05/nsub;
    if isnan(P)
        ttest_results(sub) = 0;
    else
        p_def=0.05;
        if P > p_def
            ttest_results(sub) = 0;
        else
            ttest_results(sub) = 1;
        end
    end
end

indx_learners=find(ttest_results==1);
indx_nonlearners=find(ttest_results==0);