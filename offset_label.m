function [ offset_labels, offset_data ] = offset_label(data, labels, offset_time, direction)
%OFFSET LABEL adds an offset to the signel with value equal to offset_time
%   input:
%   labels: value of the labes for 0 or 1
%   data: data to do the offset, is a TxN matrix with T eign time and N
%   features
%   offset_time: time to offset the data
%   output:
%   offset_data: data offset by the amount of time.
%   offset_labels: labels after the offset
%The signal is decreased to avoid padding with zeros at the beginning or
%end of the array
    desired_samplingRate = get_variables('Desired_Sampling_Rate'); %use the new sampling rate
    offset_samples = floor(desired_samplingRate*offset_time); %obtain offset in samples;
    offset_labels=labels;
    offset_data = data;
    switch direction %we switch depending the direction of the offset
        case 'forward'%here the labels follow the eeg
            offset_data(1:offset_samples,:)=[];%eliminate the initial values of the data
            offset_labels(end-(offset_samples-1):end)=[];%eliminate the last values
        case 'backward'%here the eeg follows the labels
            offset_data(end-(offset_samples-1):end,:)=[];%eliminate the initial values of the data
            offset_labels(1:offset_samples)=[];%eliminate the last values
    end

end

