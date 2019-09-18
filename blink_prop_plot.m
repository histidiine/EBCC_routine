function cum_BP = blink_prop_plot(gp_ID,opt)
% opt = 'sep' if each sub in subplot and 'tog' if all sub in same plot

cd(['/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/',gp_ID]);
load([gp_ID,'- blinkProp - R - .mat']);

all_BP = squeeze(all_Blink_prop_GP(:,:,1,:));

cat_BP = cat(1,squeeze(all_BP(:,1,:,1)),squeeze(all_BP(:,2,:,1)),squeeze(all_BP(:,3,:,1)),squeeze(all_BP(:,4,:,1)),...
    squeeze(all_BP(:,5,:,1)),squeeze(all_BP(:,6,:,1)),squeeze(all_BP(:,7,:,1)),squeeze(all_BP(:,8,:,1))); % cat blocks

cum_BP=cumsum(cat_BP,1);

switch opt
    
    case 'tog'
        
        figure;
        set(gcf,'units','normalized','OuterPosition',[0.3,0.3,0.25,0.65]);
        plot(cum_BP,'LineWidth',3,'Color','k');
        ylim_def=max(cum_BP(:));
        ylim([-2 70]);

    case 'sep'
        
        nsub=size(cum_BP,2);
        [row,col] = subplot_org(nsub,100);
        
        figure;
        
        for sub = 1:nsub
            subplot(row,col,sub);
            set(gcf,'units','normalized','OuterPosition',[0.3,0.3,0.25,0.65]);
            plot(cum_BP(:,sub),'LineWidth',3,'Color','k');
            ylim_def=max(cum_BP(:));
            ylim([-2 70]);
        end
        
end