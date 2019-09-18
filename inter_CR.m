function lat_CR=inter_CR(all_CR)

cat_CR = cat(1,squeeze(all_CR(:,1,:,1)),squeeze(all_CR(:,2,:,1)),squeeze(all_CR(:,3,:,1)),squeeze(all_CR(:,4,:,1)),...
    squeeze(all_CR(:,5,:,1)),squeeze(all_CR(:,6,:,1)),squeeze(all_CR(:,7,:,1)),squeeze(all_CR(:,8,:,1))); % cat blocks

cum_CR=cumsum(cat_CR,1);

cum_CR_wo_baseline=cum_CR(11:end,:)-cum_CR(10,:);

last_cum_CR = squeeze(cum_CR_wo_baseline(end,:));
lat_CR = zeros(max(last_cum_CR)+20,size(last_cum_CR,2));
for sub = 1:size(last_cum_CR,2)
    cum_CR_sub=squeeze(cum_CR_wo_baseline(:,sub));
    last_sub = last_cum_CR(1,sub);
    count=1;
    for CR = 1:last_sub+1
        curr_CR_quant = find(cum_CR_sub==CR-1);
        lat_CR(count,sub)= length(curr_CR_quant);
        count=count+1;
    end
end

% PLOT EVOLUTION OF INTER-CR LATENCIES

figure;
set(gcf,'units','normalized','OuterPosition',[0.1,0.1,0.8,0.8]);
nsub=size(lat_CR,2);
[row,col] = subplot_org(nsub,100);

for sub = 1:nsub
    subplot(row,col,sub)
    curr_lat = lat_CR(:,sub);
    curr_lat(curr_lat==0)=NaN;
    plot(curr_lat,'Color','k','LineWidth',2);
    % hold on;
    xlim([0 70])
    ylim([0 max(lat_CR(:))])
    set(gca,'FontSize',18);
    t=text(40,15,['CRs: ',num2str(last_cum_CR(1,sub))]);
    t.FontSize = 18;
    % pause;
end