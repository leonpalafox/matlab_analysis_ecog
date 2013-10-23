%This script analyses the small dataset that Mosalam and mark got on
%October 11th.
%In this dataset, they started recording the data after 1 minute.
%After the 1 minute, there were 50 seconds tih the hand not doing anything
%After those 50 seconds, he moved the hand for about 1.5 minutes
%Use this file with caution, since it is tuned to that specific dataset.
%To run this script, it is necessary too first run batched_data, to process
%all the data, it is commented out, since that script can take some time to
%process.

stop_still = 60; %Stop the still movement
start_movement = 110;%start the movement
%the difference between the start movement and the start of good data is
%the amount of samples that the patient was not moving the hand.
frequency_data = fourier_sampling_rate;
size_window_still = 3;
size_window_move = 3;
frequency_elem = size(large_power_matrix,2)/num_chan; %get the offset for each frequency component
start_good_data_in_samples = 1; %Get  the number of samples using the frequency of the fourier transform
start_movement_in_samples = floor(start_movement*frequency_data); %get the number of samples for movement, they are also the indexes
stop_still_in_samples = floor(stop_still*frequency_data);
still_data = large_power_matrix(start_good_data_in_samples:stop_still_in_samples,:);
move_data = large_power_matrix(start_movement_in_samples:end,:);
[still_windows tstill] = create_windowed_data(still_data, frequency_data, size_window_still);
[move_windows tmove] = create_windowed_data(move_data, frequency_data, size_window_move);
channel_to_plot = 2; %decide which channel to plot
channel_data_still = still_windows(frequency_elem*(channel_to_plot-1)+1:frequency_elem*(channel_to_plot),:,:); %select the data for the given channel
channel_data_move = move_windows(frequency_elem*(channel_to_plot-1)+1:frequency_elem*(channel_to_plot),:,:); 
figure(1)
sub_ax = tight_subplot(1,2);
axes(sub_ax(1));
surf(tstill, F, 10*log10(mean(channel_data_still,3)), 'edgecolor','none');
title('Still hand averaged over 2 seconds widnows')
xlabel('Time(s)')
ylabel('Frequency(Hz)')
axis tight;
view(0,90)
colorbar
colorlimits = caxis;
axes(sub_ax(2));
surf(tmove, F, 10*log10(mean(channel_data_move,3)), 'edgecolor','none');
title('Moving hand averaged over 2 seconds widnows')
xlabel('Time(s)')
ylabel('Frequency(Hz)')
axis tight;
view(0,90)
colorbar
caxis([colorlimits(1) colorlimits(2)])
set(gcf, 'color', [1,1,1])
%myaa([4 2],'windowed_spectrogram.png');
figure(2)
for channel_to_plot=2:16
    channel_data_still=(still_data(:,frequency_elem*(channel_to_plot-1)+1:frequency_elem*(channel_to_plot)));
    channel_data_move=(move_data(:,frequency_elem*(channel_to_plot-1)+1:frequency_elem*(channel_to_plot)));
    mean_still = mean(channel_data_still,1);
    zm_channel_data_move = channel_data_move -repmat(mean_still,size(channel_data_move,1),1);
    zm_channel_data_still = channel_data_still -repmat(mean_still,size(channel_data_still,1),1);
    mean_zm_still = mean(zm_channel_data_still,1);
    mean_zm_move = mean(zm_channel_data_move,1);
    sem_still = std(zm_channel_data_still,1,1)./sqrt(size(zm_channel_data_still,1));
    sem_move = std(zm_channel_data_move,1,1)./sqrt(size(zm_channel_data_move,1));
    hold on
    subplot(2,1,1);
    errorbar(F,mean_zm_still,2*sem_still,'LineWidth',0.5, 'MarkerSize',0.2,'Color',[84,84,84]/255);
    xlabel('Frequency (Hz)');    
    ylabel('Power ?? (mV^2??  Db??');
    title('Pre-squeeze: L-mean-subtracted PSD the time preceding movement w/ 95% SEM confidence intervals');
    grid on
    subplot(2,1,2);
    errorbar(F,mean_zm_move,2*sem_move, 'LineWidth',0.5, 'MarkerSize',0.2, 'Color',[84,84,84]/255);
    xlabel('Frequency (Hz)');
    ylabel('Power ?? (mV^2??  Db??');
    title('Post-squeeze: L-mean-subtracted PSD for time during movement w/ 95% SEM confidence intervals');
    grid on
end