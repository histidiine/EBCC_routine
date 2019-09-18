function plot_CR_BP_with_cluster(cidx, nsub_all, cum_CR_all, cum_BP_all, area_diff_ten_all, areaChoice, choiceFig)
% cat cum_CR and cum_BP in the same way as X (same order of groups)
% choiceFig = 'sep' or 'tog'

nsub=sum(nsub_all);
nclusters=max(cidx);
color_indx{2,:}={'g','r'};
color_indx{3,:}={'g','b','r'};
color_indx{4,:}={'g','b',[0.5977    0.1953    0.7969],'r'};
sub_init =[1 nsub_all(1)+1 nsub_all(1)+nsub_all(2)+1];
% total area

if strcmp(choiceFig,'tog') % create one figure for all
    [row,col] = subplot_org(nsub,100);
    
    figure;
    set(gcf,'units','normalized','OuterPosition',[0.25,0.05,0.5,0.98]);
    countsub=1;
end

gp=1;
for sub = 1:nsub
    
    if strcmp(choiceFig,'sep')
        if ismember(sub,sub_init) % create one figure per group
            [row,col] = subplot_org(nsub_all(gp),100);
            
            figure;
            set(gcf,'units','normalized','OuterPosition',[0.25,0.05,0.5,0.98]);
            countsub=1;
            gp=gp+1;
        end
    end
    
    subplot(row,col,countsub)
    plot(cum_CR_all(:,sub),'LineWidth',3,'Color','k');
    hold on;
    areaChoice_beg=areaChoice(1:2);
    if strcmp(areaChoice_beg,'CR')==0
        plot(cum_BP_all(:,sub),'LineWidth',3,'Color','k');
    end
    ylim([-2 70]);
    xlim([-10 90]);
    hold on;
    text(15,60,num2str(area_diff_ten_all(sub)),'FontSize',18);
    hold on;
    plot(60,60,'Color',color_indx{nclusters}{1,cidx(sub)},'Marker','.','MarkerSize',30)
    hold on;
    set(gca,'FontSize',18);
    countsub=countsub+1;
    
end

