function[LC_HV_R_550, meanLC_HV_R_550, stdLC_HV_R_550]= processNplot_LC(gp_ID,bestStr,colorNum,figDisp)

main_path = '/Users/histidiine/AMS Drive/PhD/Matlab/Matlab Data/EBCC/';
gp_colors = {'DarkCyan', 'Crimson','SandyBrown'};

% HV learning curve
cd(main_path);
[LC_HV_R_550, meanLC_HV_R_550, stdLC_HV_R_550] = LCprocess(gp_ID,bestStr,'R',550,1);
cd(main_path);
[LC_HV_L_550, meanLC_HV_L_550, stdLC_HV_L_550] = LCprocess(gp_ID,bestStr,'L',550,1);
cd(main_path);
[LC_HV_R_600, meanLC_HV_R_600, stdLC_HV_R_600] = LCprocess(gp_ID,bestStr,'R',600,1);
cd(main_path);
[LC_HV_L_600, meanLC_HV_L_600, stdLC_HV_L_600] = LCprocess(gp_ID,bestStr,'L',600,1);

if figDisp == 1
    
    % Mean HV compare eye and CRwin
    figure;
    subplot(2,2,1)
    plot(meanLC_HV_L_550,'LineWidth',3,'Color',rgb(gp_colors{colorNum}));
    title('Left 550');
    ylim([0 100]);
    subplot(2,2,2)
    plot(meanLC_HV_R_550,'LineWidth',3,'Color',rgb(gp_colors{colorNum}));
    title('Right 550');
    ylim([0 100]);
    subplot(2,2,3)
    plot(meanLC_HV_L_600,'LineWidth',3,'Color',rgb(gp_colors{colorNum}));
    title('Left 600');
    ylim([0 100]);
    subplot(2,2,4)
    plot(meanLC_HV_R_600,'LineWidth',3,'Color',rgb(gp_colors{colorNum}));
    title('Right 600');
    ylim([0 100]);
    
    % Individual HV LC LEFT 550
    figure;
    [row,col,nfig] = subplot_org(size(LC_HV_L_550,2),50);
    for sub = 1:size(LC_HV_L_550,2)
        subplot(row,col,sub)
        plot(LC_HV_L_550(:,sub),'LineWidth',3,'Color',rgb(gp_colors{colorNum}));
        title(['Sub',num2str(sub),'-L-550']);
        ylim([0 100]);
    end
    set(gcf,'units','normalized','outerposition',[0.1 0.1 0.4 0.8]);
    
    
    % Individual HV LC RIGHT 550
    figure;
    [row,col,nfig] = subplot_org(size(LC_HV_R_550,2),50);
    for sub = 1:size(LC_HV_R_550,2)
        subplot(row,col,sub)
        plot(LC_HV_R_550(:,sub),'LineWidth',3,'Color',rgb(gp_colors{colorNum}));
        title(['Sub',num2str(sub),'-R-550']);
        ylim([0 100]);
    end
    set(gcf,'units','normalized','outerposition',[0.5 0.1 0.4 0.8]);
    
    
    % Individual HV LC LEFT 600
    figure;
    [row,col,nfig] = subplot_org(size(LC_HV_L_600,2),50);
    for sub = 1:size(LC_HV_L_600,2)
        subplot(row,col,sub)
        plot(LC_HV_L_600(:,sub),'LineWidth',3,'Color',rgb(gp_colors{colorNum}));
        title(['Sub',num2str(sub),'-L-600']);
        ylim([0 100]);
    end
    set(gcf,'units','normalized','outerposition',[0.1 0.1 0.4 0.8]);
    
    % Individual HV LC RIGHT 600
    figure;
    [row,col,nfig] = subplot_org(size(LC_HV_R_600,2),50);
    for sub = 1:size(LC_HV_R_600,2)
        subplot(row,col,sub)
        plot(LC_HV_R_600(:,sub),'LineWidth',3,'Color',rgb(gp_colors{colorNum}));
        title(['Sub',num2str(sub),'-R-600']);
        ylim([0 100]);
    end
    set(gcf,'units','normalized','outerposition',[0.5 0.1 0.4 0.8]);
    
end