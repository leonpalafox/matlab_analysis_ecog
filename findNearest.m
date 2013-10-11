function [nearVal, index] = findNearest(A, S)

%
% Parameters:
%
% A: the matrix in which you want to search
%
% S: the data you are looking for in x
%
% Description:
%
% This function finds the closest value to desiredVal that exsists in x
%
% Outputs:
%
% Output one is the nearest value
%
% Output two is the index where the nearest value is found


if nargin == 2
    if all(ismember(A,S)) == 1 %% This is the O(1) case
        [nearVal index] = ismember(A, S);
    else
        index = zeros(size(A));
        nearVal = zeros(size(A));
        for idx=1:size(A,2);
            [temp, index(1,idx)] = min(abs(A(idx)-S)); %% looks for the closest value to the index
            nearVal(1,idx) = S(index(1,idx));
        end
            
    end
else
    disp('You have not entered the correct amount of parameters');
end