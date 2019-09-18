function [fit_curve,mean_dy_end,indx_max_dy,max_slope,slope_curve] = calculate_slope(cum_CR,degree)

x = 1:80;
x=x';
nsub=size(cum_CR,2);
figure;
[row,col]=subplot_org(nsub,100);
for sub = 1:nsub
    y = cum_CR(:,sub);
    p = polyfit(x,y,degree);
    
    % Evaluate the fitted polynomial p and plot:
    f = polyval(p,x);
    subplot(row,col,sub);
    plot(x,y,'k.','MarkerSize',8);
    hold on;
    plot(x,f,'r-','LineWidth',1.5);
    legend('data','linear fit');
    ylim([0 80])
    
    slope_curve(:,sub)=polyder(p);
    max_slope(sub)=max(abs(slope_curve(:,sub)));
    dx = mean(diff(x));
    dy(:,sub) = gradient(y,dx);
    for turn = 1:7
        temp(turn)=mean(dy(10+1*(10*turn-9):10+1*(10*turn),sub));
    end
    [mean_dy_end(sub),indx_max]=max(temp);
    indx_max=indx_max;
    temp_indx=indx_max*10-9;
    [~,temp_indx2]=max(dy(temp_indx:temp_indx+9));
    indx_max_dy(sub)=10+temp_indx+temp_indx2;
    fit_curve(:,sub)=f;
    mean_dy_end(sub)=mean(dy(end-19:end,sub));
%         mean_dy_end(sub)=mean(dy(:,sub));
end


