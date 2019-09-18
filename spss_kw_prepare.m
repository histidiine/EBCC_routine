function [data_spss] = spss_kw_prepare(varargin)
% INPUTS
% 1-4) datamatrices (between 2 and 4)
% last) analysisChoice = 'last' or 'area'


ngroups = nargin-1;
analysisChoice=varargin{end};
temp1=0;temp2=0;

for gp = 1:ngroups
    datamatrix{gp}=varargin{gp};
end

switch analysisChoice
    
    case 'last'
        
        % ULTIMATE CR
        for gp = 1:ngroups
            curr_data=datamatrix{gp};
            ultimate_CR=curr_data(end,:)';
            temp1= [data_spss(:,1);ultimate_CR];
            temp2=[data_spss(:,1);ones(length(ultimate_CR_1),1)*gp];
        end
        data_spss(:,1)=temp1;
        data_spss(:,2)=temp2;
        data_spss(1,:)=[];
        
    case 'area'
        
        % AREA DIFF CR - BP
        for gp = 1:ngroups
        curr_area=datamatrix{gp};
        temp1=[temp1;curr_area];
        temp2=[temp2;ones(length(curr_area),1)*gp];
        end
        data_spss(:,1)=temp1;
        data_spss(:,2)=temp2;
        data_spss(1,:)=[];
        
end
