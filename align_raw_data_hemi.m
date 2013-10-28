%align raw data to the trials
length_window = 1; %length of the window in seconds
desired_frequencies = [12:30];
[data_windows, twindows] = create_windowed_data(raw_data, desired_samplingRate, length_window);%creates windows for each trial
for chan_idx = 60:73
    figure
    chann_to_plot = chan_idx;
    channel_data = data_windows(chann_to_plot,:,:); %select the data for the given channel
    [channel_f, time_raw, num_trials] = size(channel_data);%get the features toi create the window
    trial_matrix = zeros(num_trials, time_raw);%create the place holder matrix
    for trial_idx = 1:num_trials
        trial_matrix(trial_idx,:) = channel_data(1,:,trial_idx);
    end
    surf(twindows,[1:num_trials],trial_matrix,'edgecolor','none','FaceColor','interp'); axis tight; %plot them
    view(0,90)
    title(['Raw data aligned for Channel ' num2str(chann_to_plot)])
    xlabel('Time(s)')
    ylabel('Trials')
end

%create set of labels 
threshold_value = 21000;
onset = raw_data(:,71)- raw_data(:,70);
[labels] = onset_detection(abs(onset),'Teager',threshold_value);