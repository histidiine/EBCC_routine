function plot_block_LC(varargin)
% Function that plots CR per blocks for 2 to 5 groups..
% INPUTS
% 1) gp_ID: cell containing name of groups in order
% 2)-6) mean CR of groups of interest 


        figure;
        set(gcf,'units','normalized','OuterPosition',[0.2,0.1,0.35,0.9]);
        diamondSize=10;
        
        h1=plot(varargin{2},'LineWidth',3,'Color','k','Marker','d','MarkerFaceColor','k','MarkerSize',diamondSize);
        hold on;
        h2=plot(varargin{3},'LineWidth',3,'Color','k','Marker','d','MarkerFaceColor','w','MarkerSize',diamondSize);
        hold on;
        legend([h1,h2],varargin{1}{1,1},varargin{1}{2,1});
        
        if nargin > 3
        h3=plot(varargin{4},'LineWidth',3,'Color','k','Marker','d','MarkerFaceColor',rgb('DarkGray'),'MarkerSize',diamondSize);
        hold on;
        legend([h1,h2,h3],varargin{1}{1,1},varargin{1}{2,1},varargin{1}{3,1});
        end
        
        if nargin > 4
        h4=plot(varargin{5},'LineWidth',3,'Color','k','Marker','d','MarkerFaceColor',rgb('DarkGray'),'MarkerSize',diamondSize);
        hold on;
        legend([h1,h2,h3,h4],varargin{1}{1,1},varargin{1}{2,1},varargin{1}{3,1},varargin{1}{4,1});
        end
        
        if nargin > 5
        h4=plot(varargin{6},'LineWidth',3,'Color','k','Marker','d','MarkerFaceColor',rgb('DarkGray'),'MarkerSize',diamondSize);
        hold on;
        legend([h1,h2,h3,h4,5],varargin{1}{1,1},varargin{1}{2,1},varargin{1}{3,1},varargin{1}{4,1},varargin{1}{5,1});
        end
        
        ylim([-2 10]);
        xlim([0 9]);
        set(gca,'FontSize',18);
        
end