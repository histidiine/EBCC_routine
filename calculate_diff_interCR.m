function [diff_interCR, indx_taken] = calculate_diff_interCR(cum_CR,lat_CR,calcChoice)
% calcChoice = 'diff' o 'simple'

nsub=size(cum_CR,2);

switch calcChoice
    
    case 'diff'
        
        count =1;
        for sub = 1:nsub
            total_CR=cum_CR(end,sub);
            if total_CR >3
                interCR=lat_CR(:,sub);
                interCR(interCR==0)=[];
                diff_interCR(sub)= interCR(end)-interCR(1);
                indx_taken(count)=sub;
                count=count+1;
            end
        end
        
    case 'simple'
        
        count=1;
        for sub = 1:nsub
            total_CR=cum_CR(end,sub);
            if total_CR > 2
                interCR=lat_CR(:,sub);
                interCR(interCR==0)=[];
                diff_interCR(sub)= median(interCR);
                indx_taken(count)=sub;
                count=count+1;
            end
        end
        
    case 'end'
        
        count=1;
        for sub = 1:nsub
            total_CR=cum_CR(end,sub);
            if total_CR > 2
                interCR=lat_CR(:,sub);
                interCR(interCR==0)=[];
                nCR=length(interCR);
                diff_interCR(sub)= median(interCR(end-nCR/4:end));
                indx_taken(count)=sub;
                count=count+1;
            end
        end
end