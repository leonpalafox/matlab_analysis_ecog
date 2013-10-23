function spectrogram_aligned_single_channel(channel, large_power_matrix, T, F, labels, direction, force)
%SPECTROGRAM_ALIGNED_SINGLE_CHANNEL function that plots a single channel's
%spectrogram aligned to the rising or falling edges of the given labels.
%---------------------------------------------
% input:
%---------------------------------------------
% channel: Channel number to plot
% large_power_matrix: Matrix with all the data corresponding the
% spectrogram
% T: Time information for the spectrogram
% F: Frequency content for the spectrogram
% labels: information of the rising and falling edges
% direction: cna be 'rise' or 'fall' and it will create the corresponding
% plot
%---------------------------------------------
% outpu:
%---------------------------------------------
% It plots the aligned version of the spectrogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
channel_to_plot = channel; %select channel to plot the spectrogram
num_chan = get_variables('number_of_channels');
frequency_elem = size(large_power_matrix,2)/num_chan; %get the offset for each frequency component
%get the channel data for a specific given channel
channel_data = large_power_matrix(:,frequency_elem*(channel_to_plot-1)+1:frequency_elem*(channel_to_plot));
[aligned_mat aligned_time] = align_data(labels', channel_data, direction, 1/T(1));%align to every rise in the labels
[aligned_force aligned_time] = align_data(labels', force, 'fall', 1/T(1));%align to every rise in the labels for the force
figure
subplot(4,1,1:3)
surf(aligned_time,F,10*log10(mean(aligned_mat,3)'),'edgecolor','none'); axis tight;
ylabel('Frequencies[Hz]')
title(['Averaged spectogram for channel no. ' num2str(channel)])
%line([0 0],[0 0],[0 100], 'LineWidth', 10);
view(0,90)
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',14,'fontWeight','bold')
set(gca,'FontSize',14)
subplot(4,1,4)
plot(aligned_time, mean(aligned_force,3))
%line([0 0],[0 1]);
xlabel('Time[s]')
ylabel('Force [Force Units]')
figureHandle = gcf;
set(findall(figureHandle,'type','text'),'fontSize',14,'fontWeight','bold')
set(gca,'FontSize',14)
axis tight;
end





