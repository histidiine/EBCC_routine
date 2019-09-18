function change_point = calculate_change_pt(cum_CR,analysisChoice,figChoice)
% analysisChoice = 'maxdist' or 'maxdiff' or 'diff'
% figChoice = 'with' or 'without'

nsub=size(cum_CR,2);

for sub = 1:nsub
    curr_CR=cum_CR(:,sub);
    
    switch analysisChoice
        
        case 'maxdist'
            pas=(curr_CR(end)-curr_CR(1))/79;
            ref_line= curr_CR(1):pas:curr_CR(end);
            ref_line=ref_line';
            x_axis=1:80;
            x_axis=x_axis';
            
            % --- Get the distance
            d = sqrt((x_axis-x_axis).^2 + (curr_CR-ref_line).^2);
            
            % --- Sign the distance with cross product
            u = [x_axis(:) ref_line(:)];
            u(:,3) = 0;
            
            v = [x_axis(:) curr_CR(:)];
            v(:,3) = 0;
            
            tmp = cross(u, v);
            d = d.*sign(tmp(:,3));
            [~,change_point]=max(abs(d));
            
            ref_line_all(:,sub)=ref_line;
            
        case 'maxdiff'
            pas=(curr_CR(end)-curr_CR(1))/79;
            ref_line= curr_CR(1):pas:curr_CR(end);
            ref_line=ref_line';
            diff_x=curr_CR-ref_line;
            [~,change_point]=max(abs(diff_x));
            
            ref_line_all(:,sub)=ref_line;
            
            
        case 'diff' % abandonned
            diff_CR=diff(curr_CR);
            
    end
    
    change_point_all(sub)=change_point;
end

 if strcmp(figChoice,'with')==1
       figure;
       set(gcf,'units','normalized','OuterPosition',[0.1,0.05,0.8,0.8]);
       [row,col]=subplot_org(nsub,100);
       for sub = 1:nsub
           subplot(row,col,sub)
           plot(cum_CR(:,sub),'Color','k','LineWidth',3);
           hold on;
           plot(ref_line_all(:,sub),'Color','k','LineWidth',1);
           hold on;
           plot(change_point_all(sub),cum_CR(change_point_all(sub),sub),'r.','MarkerSize',20);
           ylim([0 80])
       end
 end
    
 