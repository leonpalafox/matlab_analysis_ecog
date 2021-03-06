function [onset_labels] = onset_detection(data, method, onset_value)
%ONSET_DETECTION detects the ons
%   Input:
%-------------------------------------------------------------------------
%   data: Tx1 data variable that we will use to detect the onset 
%   onset_value: Is the value that we will use to define th onset
%-------------------------------------------------------------------------
%  Output
%-------------------------------------------------------------------------
%  onset_labels: is a 0s and 1s array that contain a 1 every time an event
%  happened, it has the same dimmensions as data
%  method: string that for the moment can only be 'Teager' that uses the
%  Teager-Kaiser energy operator
%%%

switch method
    case 'Teager'
        [time, dims] = size(data);
        onset_labels_ = zeros(time,dims);
        for time_idx = 2:time-1 %Here we Apply the Teager-Kaiser smoother
            onset_labels_(time_idx,1) = (data(time_idx))^2-(data(time_idx-1))*(data(time_idx+1));
        end
        onset_labels_ = smooth(abs(onset_labels_),100);
        %Using the output from the smoother, we use a treshold based onset
        %detection technique
        %we check if after 25 samples, certain threshold has been passed.
        %plot(onset_labels_)
        mean_data = mean(data);
        std_data = std(data);
        h_value = onset_value;
        Thresh = mean_data + h_value*std_data
        %get a logical array to get points where the threshold was passed
        onset_labels = labelize_sequence(onset_labels_,Thresh);
        
end
