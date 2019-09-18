function [vec1_hom, vec2_hom] = homogenize_vector(vec1,vec2,max_val)
% This function takes two vectors vec1 and vec2 who have different length
% (a difference of one only) and have to be homogenized;
% Or the two vectors have the same size but vec1's first element is bigger
% when it shouldn't.
%
% ** INPUTS **
% vec1 and vec2 should be vectors with either a difference in size of one
% or same size but vec1 first element is bigger than vec2 first element
% when it shouldn't
%
% ** OUTPUTS **
% vec1_hom and vec2_hom are the two input vectors who have been modified to
% be of same size with first element of vec1 bigger than first element of vec2

if ~isempty(vec1) && ~isempty(vec2) % check if vectors are emtpy
    length1= length(vec1);
    length2= length(vec2);
    while length(vec1) ~= length(vec2) 
        if length1 > length2 % in case the cr timewindow finished while above threshold 
            vec2(end+1,1) = max_val; % add a last entry to end
        else if length2 > length1  % in case the cr timewindow started while above threshold
                %             vec1 = [1 vec1']'; % add a first entry to start
                vec2(1)=[]; % remove first element of end because we don't want to count responses that started before 200 ms before stim
            else if vec1(1)>vec2(1) % in case of both of the above
                    vec1 = [1 vec1']';
                    vec2(end+1,1) = max_val;
                end
            end
        end
    end
end
vec1_hom=vec1;
vec2_hom=vec2;
