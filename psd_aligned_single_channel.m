function psd_aligned_average_channel(large_power_matrix, T, F, labels, direction, force)
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

num_chan = get_variables('number_of_channels');
frequency_elem = size(large_power_matrix,2)/num_chan; %get the offset for each frequency component
%get the channel data for a specific given channel
for chan_idx = 1:num_chan
    channel_to_plot = chan_idx; %select channel to plot the spectrogram
    channel_data = large_power_matrix(:,frequency_elem*(channel_to_plot-1)+1:frequency_elem*(channel_to_plot));
    [aligned_mat aligned_time] = align_data(labels', channel_data, direction, 1/T(1));%align to every rise in the labels
    [left_side_aligned, right_side_aligned, left_side_time, right_side_time] = separate_aligned_data(aligned_mat, aligned_time, T);


    sd_left_side_aligned = shiftdim(left_side_aligned,1);%rearrange dimensions so we can take the std in one shot
    sd_right_side_aligned = shiftdim(right_side_aligned,1);%rearrange dimensions so we can take the std in one shot    
    
    dim_sd_L = size(sd_left_side_aligned); %get the dimensions of the arrays

    dim_sd_R = size(sd_right_side_aligned);%get the dimension of the right array
    
    reshaped_sd_L = reshape(sd_left_side_aligned,dim_sd_L(1),prod(dim_sd_L(2:3)));%rearrange fot the std calculations
    reshaped_sd_R = reshape(sd_right_side_aligned,dim_sd_R(1),prod(dim_sd_R(2:3)));    
    
    mean_spect_L = mean(reshaped_sd_L,2);%obtain the mean of the data
    std_spect_L  = std(reshaped_sd_L,1,2); %obtain the std of the data
    mean_spect_R = mean(reshaped_sd_R,2);
    std_spect_R  = std(reshaped_sd_R,1,2);    

    zm_reshaped_sd_L = reshaped_sd_L - repmat(mean_spect_L,1,size(reshaped_sd_L,2));  %matrix minus vector - may throw error
    zm_reshaped_sd_R = reshaped_sd_R - repmat(mean_spect_L,1,size(reshaped_sd_R,2));  %convert into a 0 mean array

    mean_zm_L = mean(zm_reshaped_sd_L,2);
    sem_zm_L = std(zm_reshaped_sd_L,1,2)./sqrt(size(zm_reshaped_sd_L,2));  %compute the standard error of the mean
    mean_zm_R = mean(zm_reshaped_sd_R,2);
    sem_zm_R = std(zm_reshaped_sd_R,1,2)./sqrt(size(zm_reshaped_sd_R,2));  %compute the standard error of the mean
    
    figure(1);
    hold on
    subplot(3,1,1);
    errorbar(F,mean_zm_L,2*sem_zm_L);
    xlabel('Frequency (Hz)');    
    ylabel('Power ?? (mV^2??  Db??');
    title('Pre-squeeze: L-mean-subtracted PSD for 1-second window preceeding squeeze onset w/ 95% SEM confidence intervals');
    subplot(3,1,2);
    errorbar(F,mean_zm_R,2*sem_zm_R);
    xlabel('Frequency (Hz)');
    ylabel('Power ?? (mV^2??  Db??');
    title('Post-squeeze: L-mean-subtracted PSD for 1-second window following squeeze onset w/ 95% SEM confidence intervals');

    
end

% figure(1)
% grid on
% ylabel('Power')
% xlabel('Frequency[Hz]')
% [ylim] = get(gca,'YLim');
% [xlim] = get(gca, 'XLim');
% text(0.5*xlim(2), 0.5*ylim(2),['Averaged across ' num2str(size(aligned_mat,3)) ' trials per channel'])
% title(['Pre-squeeze -> Squeeze Spectrograms for different channels'])
% %line([0 0],[0 0],[0 100], 'LineWidth', 10);
% figureHandle = gcf;
% set(findall(figureHandle,'type','text'),'fontSize',14,'fontWeight','bold')
% set(gca,'FontSize',14)
% 
% figure(2)
% grid on
% ylabel('Power')
% xlabel('Frequency[Hz]')
% [ylim] = get(gca,'YLim');
% [xlim] = get(gca, 'XLim');
% text(0.5*xlim(2), 0.5*ylim(2),['Averaged across ' num2str(size(aligned_mat,3)) ' trials per channel'])
% title(['Pre-squeeze Spectrograms for different channels'])
% %line([0 0],[0 0],[0 100], 'LineWidth', 10);
% figureHandle = gcf;
% set(findall(figureHandle,'type','text'),'fontSize',14,'fontWeight','bold')
% set(gca,'FontSize',14)
% 
% figure(3)
% grid on
% ylabel('Power')
% xlabel('Frequency[Hz]')
% [ylim] = get(gca,'YLim');
% [xlim] = get(gca, 'XLim');
% text(0.5*xlim(2), 0.5*ylim(2),['Averaged across ' num2str(size(aligned_mat,3)) ' trials per channel'])
% title(['During first one second of Squeeze Spectrograms for different channels'])
% %line([0 0],[0 0],[0 100], 'LineWidth', 10);
% figureHandle = gcf;
% set(findall(figureHandle,'type','text'),'fontSize',14,'fontWeight','bold')
% set(gca,'FontSize',14)





set(gcf, 'color', [1,1,1])
myaa([4 2],'aligned_psd.png');
end


%title(['Pre-squeeze Spectrograms for different channels'])
%title(['During-squeeze Spectrograms for different channels'])