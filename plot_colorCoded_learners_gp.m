function learning_dm=plot_colorCoded_learners_gp(cum_CR,nsub_all,cidx,color_indx)

ncluster=max(cidx(:));
cum_CR_wo_baseline=cum_CR(11:end,:)-cum_CR(10,:);
sub_init=1;
for gp = 1:length(nsub_all)
    sub_init =[sub_init sum(sub_init)+nsub_all(gp)-1];
    datamatrix_gp=cum_CR_wo_baseline(:,sub_init(gp):sub_init(:,gp+1));
    cidx_gp=cidx(sub_init(gp):sub_init(:,gp+1));
    for cl = 1:ncluster
       learning_dm{cl,gp}= datamatrix_gp(:,cidx_gp==cl);
    end
end


for gp=1:length(nsub_all)
    figure;
    set(gcf,'units','normalized','OuterPosition',[0.25,0.2,0.35,0.85]);
    for sub = sub_init(gp):sub_init(gp+1)
        plot(cum_CR_wo_baseline(:,sub),'LineWidth',3,'Color',color_indx{ncluster}{1,cidx(sub)});
        hold on;
    end
    ylim([-2 70]);
    xlim([-10 90]);
    set(gca,'FontSize',18);
end