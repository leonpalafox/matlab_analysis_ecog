function [windowed_data, windowed_time] = create_windowed_data(data, sampling_frequency, size_window)
%CREATE_WINDOWED_DATA creates windows from the given data array
%   Input:
%-------------------------------------------------------------------------
%   data: Data to get the windows from, it has to be in the same format
%   TxD, where T is the time and D is the features.
%   sampling_frequency: Is the sampling frequency, used to get the size of
%   the batch given the window size in seconds.
%   size_window: Size of the window in seconds, if it is not compatible, it
%   will reshape the data so the windows have the same size
%   dimension: decides how the output is going to be, if a 3D array or a 2D
%   array
%-------------------------------------------------------------------------
%  Output
%   windowed_data: and array of size DxTIMExTrial, where time is the size
%   of the window in samples.
%   windowed_time: time array useful for ploting

%-------------------------------------------------------------------------
%  
%%%
[time_data, feat_data] = size(data);
size_window_samples = floor(sampling_frequency * size_window); % get the size of the window in samples
while mod(time_data, size_window_samples)~=0 %if the desired window is not compatible
    %reshape the data so until becomes compatible
    data(end,:) = [];
    [time_data, feat_data] = size(data);
    
end
data = data';%We need to transpose so the reshape can work in one swoop
windowed_data = reshape(data,feat_data,size_window_samples,time_data/size_window_samples);
windowed_time = (1:size_window_samples)/sampling_frequency;
