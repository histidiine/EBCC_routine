function chosenArea = diff_area_CR_prop(cum_CR,cum_BP,plotChoice,areaChoice)
% plotChoice = 'with' to have a plot with both curves and values and
% 'without' if not
% areaChoice = 'all', 'base' or 'ten' or 'CRonly' or 'CRonly_base' or 'CRonly_ten'

nsub = size(cum_CR,2);

for sub = 1:nsub
    curr_cum = cum_CR(:,sub);
    curr_bp = cum_BP(:,sub);
    switch areaChoice
        
        case 'all'
            % area between CR and BP
            area_CR = trapz(curr_cum);
            area_BP = trapz(curr_bp);
            area_between(sub) = area_CR - area_BP;
            chosenArea=area_between;
            
        case 'base'
            % diff baseline
            area_CR_base = trapz(curr_cum(1:10));
            area_BP_base = trapz(curr_bp(1:10));
            area_CR_post = trapz(curr_cum(11:end));
            area_BP_post = trapz(curr_bp(11:end));
            diff_base = area_CR_base-area_BP_base;
            diff_post = area_CR_post-area_BP_post;
            area_diff(sub) = diff_post - diff_base;
            chosenArea=area_diff;
            
        case 'ten'
            % diff ten first ten last
            area_CR_base = trapz(curr_cum(1:10));
            area_BP_base = trapz(curr_bp(1:10));
            area_CR_post = trapz(curr_cum(end-9:end));
            area_BP_post = trapz(curr_bp(end-9:end));
            diff_base = area_CR_base-area_BP_base;
            diff_post = area_CR_post-area_BP_post;
            area_diff_ten(sub) = diff_post - diff_base;
            chosenArea=area_diff_ten;
            
        case 'CRonly'
            area_CR(sub) = trapz(curr_cum);
            chosenArea=area_CR;
            
        case 'CRonly_base'
            % diff baseline
            diff_base = trapz(curr_cum(1:10));
            diff_post = trapz(curr_cum(11:end));
            area_diff(sub) = diff_post - diff_base;
            chosenArea=area_diff;
            
        case 'CRonly_ten'
            % diff ten first ten last
            diff_base = trapz(curr_cum(1:10));
            diff_post = trapz(curr_cum(end-9:end));
            area_diff_ten(sub) = diff_post - diff_base;
            chosenArea=area_diff_ten;
    end
    
end

if strcmp(plotChoice,'with') % plotchoice
    
    areaChoice_beg=areaChoice(1:2);
    nsub=size(cum_CR,2);
    [row,col] = subplot_org(nsub,100);
    
    figure;
    set(gcf,'units','normalized','OuterPosition',[0.25,0.05,0.5,0.98]);
    
    for sub = 1:nsub
        subplot(row,col,sub)
        plot(cum_CR(:,sub),'LineWidth',3,'Color','k');
        hold on;
        if strcmp(areaChoice_beg,'CR')==0
            plot(cum_BP(:,sub),'LineWidth',3,'Color','k');
        end
        ylim([-2 70]);
        xlim([-10 90]);
        %         x_str=60;
        %         y_str=(cum_CR(x_str,sub)+cum_BP(x_str,sub))/2;
        text(15,60,num2str(chosenArea(sub)),'FontSize',18);
        set(gca,'FontSize',18);
    end
    
end