function cum_CR = plot_ind_cumulative_CR(all_CR, gp_str, baseChoice,opt)
% function that plots cumulative CR of each individual in a group
% opt = 'sep' if each sub in subplot and 'tog' if all sub in same plot

% cat_CR = cat(1,squeeze(all_CR(:,1,:,1)),squeeze(all_CR(:,2,:,1)),squeeze(all_CR(:,3,:,1)),squeeze(all_CR(:,4,:,1)),...
%     squeeze(all_CR(:,5,:,1)),squeeze(all_CR(:,6,:,1)),squeeze(all_CR(:,7,:,1)),squeeze(all_CR(:,8,:,1))); % cat blocks
% 
% cum_CR=cumsum(cat_CR,1);

cum_CR=all_CR;

switch opt
    
    case 'tog' % all individual on same plot
        
        switch baseChoice
            
            case 1 % with baseline
                
                figure;
                set(gcf,'units','normalized','OuterPosition',[0.25,0.2,0.35,0.85]);
                h1=plot(cum_CR,'LineWidth',3,'Color','k');
                hold on;
                ylim([-2 70]);
                xlim([-10 90]);
                set(gca,'FontSize',18);
                title(gp_str);
                
            case 0 % without baseline
                
                cum_CR_wo_baseline=cum_CR(11:end,:)-cum_CR(10,:);
                
                figure;
                set(gcf,'units','normalized','OuterPosition',[0.25,0.2,0.35,0.85]);
                for sub = 1:size(cum_CR_wo_baseline,2)
                    h1=plot(cum_CR_wo_baseline(:,sub),'LineWidth',3,'Color','k');
                    hold on;
                    ylim([-2 70]);
                    xlim([-10 90]);
                end
                set(gca,'FontSize',18);
                title(gp_str);
        end
        
    case 'sep' % each individual in a separate subplot
        
        switch baseChoice
            
            case 1 % with baseline
                
                figure;
                set(gcf,'units','normalized','OuterPosition',[0.25,0.2,0.35,0.85]);
                
                nsub=size(cum_CR,2);
                [row,col,nfig] = subplot_org(nsub,100)
                
                for sub = 1:nsub
                    subplot(row,col,sub)
                    h1=plot(cum_CR(:,sub),'LineWidth',3,'Color','k');
                    ylim([-2 70]);
                    xlim([-10 90]);
                    set(gca,'FontSize',18);
                    title([gp_str,num2str(sub)]);
                end
                
            case 0 % without baseline
                
                cum_CR_wo_baseline=cum_CR(11:end,:)-cum_CR(10,:);
                
                figure;
                set(gcf,'units','normalized','OuterPosition',[0.25,0.2,0.35,0.85]);
                
                nsub=size(cum_CR_wo_baseline,2);
                [row,col,nfig] = subplot_org(nsub,100);
                
                for sub = 1:size(cum_CR_wo_baseline,2)
                    subplot(row,col,sub)
                    h1=plot(cum_CR_wo_baseline(:,sub),'LineWidth',3,'Color','k');
                    hold on;
                    ylim([-2 70]);
                    xlim([-10 90]);
                    set(gca,'FontSize',18);
                    title([gp_str,num2str(sub)]);
                end
        end
end