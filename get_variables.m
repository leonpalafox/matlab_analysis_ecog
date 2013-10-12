function [ variable ] = get_variables( variable_name )
%This function consolidates all the significant variables in a single file,
%so we do not need to set them by hand in each individual file
%   Input:
%-------------------------------------------------------------------------
%   variable_name: name of the variable to get its value
%-------------------------------------------------------------------------
%  Output
%-------------------------------------------------------------------------
%  vairable: value of the variable
%%%

switch variable_name
    case 'number_of_channels'
        %desired number of channels to work with
        variable = 3;
    case 'Original_Sampling_Rate'
        variable = 25000;
    case 'Desired_Sampling_Rate'
        variable = 500;
    case 'Window_Size'
        variable = 0.300;
    case 'number_recorded_channels'
        %number of channels recorded
        variable = 16;
        
        
end



end

