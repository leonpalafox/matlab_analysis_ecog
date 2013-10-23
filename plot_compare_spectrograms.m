%PLOT_COMPARE_SPECTROGRAMS plots a 2x1 plot that compares the time when the
%subject was doing movements and when he was still.
%It allows us to set desired frequency bands to do the analysis.
%It has to be run after analyze data, so the variables that are set there,
%like the whole array containing the still data and the whole array
%containing the movement data are extracted.
channel_to_plot = 2; %decide which channel to plot
channel_data_still = still_data(:,frequency_elem*(channel_to_plot-1)+1:frequency_elem*(channel_to_plot))'; %select the data for the given channel
channel_data_move = move_data(:,frequency_elem*(channel_to_plot-1)+1:frequency_elem*(channel_to_plot))'; 
[freq_still ntp_still] = size(channel_data_still);
time_still = [1:ntp_still]/frequency_data;
[freq_move ntp_move] = size(channel_data_move);
time_move = [1:ntp_move]/frequency_data;
figure
subplot(2,2,1)
surf(time_move, F, 10*log10(channel_data_move), 'edgecolor','none');
title('Raw data spectrogram for the time when the patient is moving their fingers')
xlabel('Time(s)')
ylabel('Frequency(Hz)')
axis tight;
xlimit = get(gca,'XLim');
ylimit = get(gca,'YLim');
view(0,90)
subplot(2,2,3)
surf(time_still, F, 10*log10(channel_data_still), 'edgecolor','none');
title('Raw data spectrogram for the time when the patient is still')
xlabel('Time(s)')
ylabel('Frequency(Hz)')
xlim(xlimit)
ylim(ylimit)
view(0,90)
subplot(2,2,2)
spectogram_single_channel(2, large_power_matrix, T_axis, F)%Plot the spectrogram of the first channel
title('Raw Data and Spectrogram associated with the working data file')
xlimit = get(gca, 'XLim');
xlim([0, xlimit(2)])
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',14,'fontWeight','bold')
subplot(2,2,4)
plot(raw_time_axis, raw_data)%Plot the raw data
xlim([0, xlimit(2)])
set(gca,'Color',[1 1 1]);
grid on
xlabel('Time(s)')
ylabel('Volts')
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',14,'fontWeight','bold')
set(gca,'FontSize',14)
 



figure
%plot the comparisson of given bands
slide_freq = 5; %define the slide in hertz
freq_window = 15;
num_plots=15;
for plot_idx = 1:num_plots
    lower_freq = (plot_idx-1)*slide_freq+1;
    higher_freq = lower_freq + freq_window-1;
    desired_frequencies = [lower_freq:higher_freq]; %Frequencies in the Beta Band
    subplot(num_plots/3,3,plot_idx)
    frequency_matrix = zeros(num_chan, length(time_move)); %matrix that has channels in the rows and time in the X, to plot averaged frequencies
    for chan_idx = 1:num_chan
        chan_power_mat = move_data(:,(chan_idx-1)*length(F)+1:chan_idx*length(F)); %extract the info for the current channel
        channel_frequency_move = extract_frequency(chan_power_mat, F, desired_frequencies, 'average'); %extract the frequencies that we want
        frequency_matrix(chan_idx,:) = channel_frequency_move;%assigns those frequencies to the channel
    end
    surf(time_move,[1:num_chan],10*log10(frequency_matrix),'edgecolor','none'); axis tight; %plot them
    xlabel('Time(s)')
    ylabel('Channel')
    axis tight;
    title(['Move Band from ' num2str(lower_freq) ' to ' num2str(higher_freq)])
    %set variables so both plots have the same scales
    xlimit = get(gca,'XLim');
    ylimit = get(gca,'YLim');
    colorbar
    colorlimits = caxis;%get the color bar scale
    if plot_idx == 1
        color_vector = colorlimits; %save the color limits to use them in the next set of plots, in the same order
    else
        color_vector = [color_vector; colorlimits];%append new colors
    end
    view(0,90)%change the view
end

figure
for plot_idx = 1:num_plots
    lower_freq = (plot_idx-1)*slide_freq+1;
    higher_freq = lower_freq + freq_window-1;
    desired_frequencies = [lower_freq:higher_freq]; %Frequencies in the Beta Band
    subplot(num_plots/3,3,plot_idx)
    frequency_matrix = zeros(num_chan, length(time_still)); %matrix that has channels in the rows and time in the X, to plot averaged frequencies
    for chan_idx = 1:num_chan
        chan_power_mat = still_data(:,(chan_idx-1)*length(F)+1:chan_idx*length(F)); %extract the info for the current channel
        channel_frequency_still = extract_frequency(chan_power_mat, F, desired_frequencies, 'average'); %extract the frequencies that we want
        frequency_matrix(chan_idx,:) = channel_frequency_still;%assigns those frequencies to the channel
    end
    surf(time_still,[1:num_chan],10*log10(frequency_matrix),'edgecolor','none'); axis tight; %plot them
    axis tight;
    title(['Still Band from ' num2str(lower_freq) ' to ' num2str(higher_freq)])
    xlabel('Time(s)')
    ylabel('Channel')
    %set variables so both plots have the same scales
    xlim(xlimit)
    ylim(ylimit)
    colorbar
    plot_idx
    caxis([color_vector(plot_idx, 1) color_vector(plot_idx, 2)])%set the same color bar scale
    view(0,90)%change the view
end


% figure
% subplot(2,1,1)
% frequency_matrix = zeros(num_chan, length(time_still)); %matrix that has channels in the rows and time in the X, to plot averaged frequencies
% for chan_idx = 1:num_chan
%     chan_power_mat = still_data(:,(chan_idx-1)*length(F)+1:chan_idx*length(F)); %extract the info for the current channel
%     channel_frequency_still = extract_frequency(chan_power_mat, F, desired_frequencies, 'average'); %extract the frequencies that we want
%     frequency_matrix(chan_idx,:) = channel_frequency_still;%assigns those frequencies to the channel
% end
% surf(time_still,[1:num_chan],10*log10(frequency_matrix),'edgecolor','none'); axis tight; %plot them
% xlim(xlimit)
% ylim(ylimit)
% colorbar
% caxis([colorlimits(1) colorlimits(2)])%set the same color bar scale
% view(0,90)%change the view
