function [data_array, time_axis] = align_data(labels, data, edges, sampling_frequency)
%script to align data to rising and fallling edges
%the script gets the data and the labels, and it
%input:
%labels: sets of 1s and 0s to align the data with
%data: original data, which is already aligned, so it shares the same
%indexes
%output:
%It generates a plot of the aligned data.
%Set Parameters
size_right = get_variables('right_limit'); %length of the signal ahead of the offset (seconds)
size_left = get_variables('left_limit');%length of the signal after the offset (seconds)
size_right_samples = floor(size_right*sampling_frequency);%get the right size in samples
size_left_samples = floor(size_left*sampling_frequency);%get the left size in samples
total_samples_per_trial = size_right_samples + size_left_samples;%get the toal number of samples per trial
[data_time, features] = size(data); %get the features to construct the squeleton
switch edges
    case 'rise'
        edge_idx = find(diff(labels)>0);%find the uprising edges indexes
    case 'fall' 
        edge_idx = find(diff(labels)<0);%find the falling edges indexes
        
end
trials = length(edge_idx);%get the number of trials based on the number of falling or rising edges
%construct squeleton to allocate data
data_array = zeros(total_samples_per_trial, features, trials);
count_trial =1;
if(size(edge_idx,1)~=1)
    edge_idx = edge_idx';
end
for idx = edge_idx
    left_limit = idx - size_left_samples; %set the index of the left part
    right_limit = idx + size_right_samples;%set the index of the right part
    if left_limit<0%if the limit is less than zero it means is not consistent with out choice
        left_samples = size_left_samples - abs(left_limit); 
        left_limit = 1;
        data_array(end-(left_samples+size_right_samples-1):end,:,count_trial) = data(left_limit:right_limit,:);
         
    
    elseif right_limit>data_time %if the index is larger than our data
        right_limit = data_time;
        right_samples = right_limit - idx;
        data_array(1:size_left_samples+right_samples,:,count_trial) = data(left_limit:right_limit-1,:);
    else
        data_array(:,:,count_trial) = data(left_limit:right_limit-1,:);
    end
    count_trial = count_trial + 1;
    
end
time_axis = ([1:total_samples_per_trial]-size_left_samples)/sampling_frequency;

end