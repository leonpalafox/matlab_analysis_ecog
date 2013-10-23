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
        variable = 16;
    case 'Original_Sampling_Rate'
        variable = 25000;
    case 'Desired_Sampling_Rate'
        variable = 300;
    case 'Window_Size'
        variable = 0.300;
    case 'number_recorded_channels'
        %number of channels recorded
        variable = 60;
    case 'overlap_percentage'
        variable = 0.750;
    case 'Reference_Channel'
        variable = 1; %use channel 1 as reference, it can be changed to any channel 
    case 'right_limit'
        variable = 2; %limit of the right side in seconds
    case 'left_limit'
        variable = 2; %limit of the left side in seconds
        
        
end



end

