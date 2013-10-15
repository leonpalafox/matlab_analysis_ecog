%plot spectogram for different channels
channel_to_plot = 1;
frequency_elem = size(large_power_matrix,2)/num_chan;
channel_data = large_power_matrix(:,frequency_elem*(channel_to_plot-1):frequency_elem*(channel_to_plot));
surf(T_axis,F,10*log10(channel_data),'edgecolor','none'); axis tight;