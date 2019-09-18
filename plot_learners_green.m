function plot_learners_green(all_CR,indx_learners)

cat_CR = cat(1,squeeze(all_CR(:,1,:,1)),squeeze(all_CR(:,2,:,1)),squeeze(all_CR(:,3,:,1)),squeeze(all_CR(:,4,:,1)),...
    squeeze(all_CR(:,5,:,1)),squeeze(all_CR(:,6,:,1)),squeeze(all_CR(:,7,:,1)),squeeze(all_CR(:,8,:,1))); % cat blocks

cum_CR=cumsum(cat_CR,1);

cum_CR_wo_baseline=cum_CR(11:end,:)-cum_CR(10,:);

figure;
set(gcf,'units','normalized','OuterPosition',[0.25,0.2,0.35,0.85]);
for sub = 1:size(cum_CR_wo_baseline,2)
    if ismember(sub,indx_learners)
        curr_color=rgb('SpringGreen');
    else
        curr_color='k';
    end
    h1=plot(cum_CR_wo_baseline(:,sub),'LineWidth',3,'Color',curr_color);
    hold on;
%     pause;
end
ylim([-2 70]);
xlim([-10 90]);
set(gca,'FontSize',18);