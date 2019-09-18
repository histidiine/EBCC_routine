function [age_mat,tso_mat,btx_mat,hadA_mat,hadD_mat,twist_mat]=Col2Mat(tableTXT,tableNUM,nbLines,CDtest)
% Correct this function to have varargin and let the choice to the user of
% the column names he wants to use to extract mats

[~, indx_age] = findcell(tableTXT,'Age Then',1);
age_mat = tableNUM(1:nbLines,indx_age-1);
% Column TSO
[~, indx_tso] = findcell(tableTXT,'TSO then',1);
tso_mat = tableNUM(1:nbLines,indx_tso-1);
% Column BTX
[~, indx_btx] = findcell(tableTXT,'Botox (y/n)',1);
btx_mat = tableTXT(2:nbLines,indx_btx);
% btx_mat(strcmp(btx_mat,'y'))=1;
% btx_mat(strcmp(btx_mat,'n'))=0;
% Column HAD Anxiety
[~, indx_hadA] = findcell(tableTXT,'HAD Anxiety score',1);
hadA_mat = tableNUM(1:nbLines,indx_hadA-1);
% Column HAD Depression
[~, indx_hadD] = findcell(tableTXT,'HAD Depression score',1);
hadD_mat = tableNUM(1:nbLines,indx_hadD-1);
% Column TWSTRS Severity
if CDtest ==1
[~, indx_twist] = findcell(tableTXT,'TWSTRS Severity',1);
twist_mat = tableNUM(1:nbLines,indx_twist-1);
end

end