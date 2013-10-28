function [labels] = labelize_sequence(data, threshold)
%Function to obtaion discrete labels from the force sensors, in this case,
%we detect the first threshold passing, instead of just comparing.
%   input:
%   data: raw data from the force sensor
%   threshold: threshold to determine when a data point is considered a one
%   Output:
%   labels: 0s and 1s, where we have 0 for not an onset and 1 for an onset
[ntp, dim] = size(data);
labels = zeros(ntp, dim); %generate the placeholder array
data_onset = 0;
data_offset =0;
offset_idx = 1;
num_counts=250;
for data_idx = 2:ntp
    if data(data_idx,1)>threshold%if a datapoint crossed the threshold
        data_onset = data_onset+1;
        data_offset = 0;
        if data(data_idx-1,1)<threshold %if is coming from a down state
            start_idx = data_idx;%record the index
        end
        if data_onset==num_counts
            labels(start_idx:end,1) = 1;
        end
    else
        data_onset = 0;
        data_offset = data_offset + 1;
        if data(data_idx-1,1) > threshold %is cominf grom an upstate
            offset_idx = data_idx;
        end
        if data_offset ==num_counts
            labels(offset_idx:end,1) = 0;
        end
    end

end

