function plot_boxplot(varargin)
% INPUTS
% 1-4) datamatrices (between 2 and 4)
% last) analysisChoice = 'last'

ngroups = nargin-1;
max_check=0;

for gp = 1:ngroups
    datamatrix{gp}=varargin{gp};
    if size(datamatrix{gp},1)==1
        max_all(gp)=max(datamatrix{gp});
        max_check=1;
    end
end
analysisChoice=varargin{end};

if max_check==1
ylim_def=max(max_all)+0.05*max(max_all);
end

switch analysisChoice
    
    case 'last'

        for gp = 1:ngroups
            temp=datamatrix{gp};
            data_last{gp}=temp(end,:);
            
            figure;
            set(gcf,'units','normalized','OuterPosition',[0.3,0.3,0.25,0.65]);
            boxplot(data_last{gp}');
            ylim([-2 80]);
        end

    case 'area'
        
        for gp=1:ngroups
            
            
            figure;
            set(gcf,'units','normalized','OuterPosition',[0.3,0.3,0.25,0.65]);
            boxplot(datamatrix{gp}');
            ylim([0 ylim_def]);
        end
        
end

