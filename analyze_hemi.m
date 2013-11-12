%Analyze the Hemi data and create he plots of channels and frequencies.
%Analyze_Hemi creates the plots in Page 6 of Brad Voytek Hemicraniectomy Paper 
%It used data created by the script batched_data_analysis.m
%
frequency_elem = size(large_power_matrix,2)/num_chan; %get the offset for each frequency component
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%And we create plots for averages over different trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code generates the plots that is in the Figure 6 in the
%Hemicraneoctomy Paper, here it createsa plot per channel.


frequency_matrix = zeros(num_chan-8, length(T_axis)); %matrix that has channels in the rows and time in the X, to plot averaged frequencies
desired_frequencies = [65:115]; %Frequencies in the Beta Band
for chan_idx = 1:num_chan-8
    figure %creates a new figure per channe.
    chan_power_mat = large_power_matrix(:,(chan_idx-1)*length(F)+1:chan_idx*length(F)); %extract the info for the current channel
    [aligned_mat aligned_time] = align_data(large_labels', chan_power_mat, 'rise', fourier_sampling_rate);%align to every rise in the labels
    [aligned_force aligned_time] = align_data(large_labels', large_force, 'rise',fourier_sampling_rate);%align to every rise in the labels for the force
    [time_freq, channel_f, num_trials] = size(aligned_mat);%get the features toi create the window
    trial_matrix = zeros(num_trials, time_freq);%create the place holder matrix
    for trial_idx = 1:num_trials
        channel_frequency = extract_frequency(aligned_mat(:,:,trial_idx), F, desired_frequencies, 'average'); %extract the frequencies that we want
        trial_matrix(trial_idx,:) = channel_frequency;%assigns those frequencies to the channel
    end
    subplot(4,1,1:3)
    surf(aligned_time,[1:num_trials],log10(trial_matrix),'edgecolor','none','FaceColor','interp'); axis tight; %plot them
    view(0,90)
    title(['[15 to 30] Hz Trials aligned for Channel ' num2str(chan_idx)])
    xlabel('Time(s)')
    ylabel('Trials')
    subplot(4,1,4)
    plot(aligned_time, mean(aligned_force,3))
    xlabel('Time[s]')
    ylabel('Force [Force Units]')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Plot aligned trials for the averaged channels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

frequency_matrix = zeros(num_chan-8, length(T_axis)); %matrix that has channels in the rows and time in the X, to plot averaged frequencies
desired_frequencies = [65:115]; %Frequencies in the Beta Band
chan_power_mat(:,:) = 0; %reinitialize so we can put the averages here
for chan_idx = 1:num_chan-8
    chan_power_mat = chan_power_mat + large_power_matrix(:,(chan_idx-1)*length(F)+1:chan_idx*length(F)); %extract the info for the current channel
end
chan_power_mat = chan_power_mat/(num_chan-8);
[aligned_mat aligned_time] = align_data(large_labels', chan_power_mat, 'rise', fourier_sampling_rate);%align to every rise in the labels
[aligned_force aligned_time] = align_data(large_labels', large_force, 'rise', fourier_sampling_rate);%align to every rise in the labels for the force
[time_freq, channel_f, num_trials] = size(aligned_mat);%get the features toi create the window
trial_matrix = zeros(num_trials, time_freq);%create the place holder matrix
for trial_idx = 1:num_trials
    channel_frequency = extract_frequency(aligned_mat(:,:,trial_idx), F, desired_frequencies, 'average'); %extract the frequencies that we want
    trial_matrix(trial_idx,:) = channel_frequency;%assigns those frequencies to the channel
end
subplot(4,1,1:3)
surf(aligned_time,[1:num_trials],(trial_matrix),'edgecolor','none','FaceColor','interp'); axis tight; %plot them
view(0,90)
title(['[15 to 30] Hz Trials aligned for Averaged Channels '])
xlabel('Time(s)')
ylabel('Trials')
subplot(4,1,4)
plot(aligned_time, mean(aligned_force,3))
xlabel('Time[s]')
ylabel('Force [Force Units]')



