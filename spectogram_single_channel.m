function spectogram_single_channel(channel, large_power_matrix, T, F)
%plot spectogram for different channels
    channel_to_plot = channel; %select channel to plot the spectrogram
    num_chan = get_variables('number_of_channels');
    frequency_elem = size(large_power_matrix,2)/num_chan; %get the offset for each frequency component
    channel_data = large_power_matrix(:,frequency_elem*(channel_to_plot-1)+1:frequency_elem*(channel_to_plot));
    %get the information from a specific channel
    surf(T,F,10*log10(channel_data'),'edgecolor','none'); axis tight;
    xlabel('Time (sec)');
    ylabel('Frequency (Hz)');


    view(0,90);
end