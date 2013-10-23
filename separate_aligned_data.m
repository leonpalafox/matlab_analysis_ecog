function [left_signal, right_signal, left_time, right_time] = separate_aligned_data(aligned_mat, aligned_time, T)
%SEPARATE_ALIGNED_DATA separets a set of aligned data into two. it is used
%to separate data from befor and after a raising or falling edge
%its input used the output of align_data
%---------------------------------------------
% input:
%---------------------------------------------
% aligned_mat: Matrix preiously aligned using aligned_data, of size (TxFxTrials)
% aligned_time:  Also computed in aligned_data, it has the time axis for
% plotting purposes
% T: Time information for the spectrogram
% %---------------------------------------------
% outpu:
%---------------------------------------------
% left_signal: Aligned set of data that happens before a rise or a fall
%right signal: Aligned set of data that happens after a rise or a fall
%left_time: time axis for the signal happening before a rise or a fall
%right_time: time axis for the signal happening after a rise or a fall
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left_limit = get_variables('left_limit'); %get the left limit of the aligned array in seconds
right_limit = get_variables('right_limit'); %get the left limit of the aligned array in seconds
size_right_samples = floor(right_limit*1/T(1));%get the right size in samples
size_left_samples = floor(left_limit*1/T(1));%get the left size in samples
left_signal = aligned_mat(1:size_left_samples,:,:); %Get the left side of the signal
right_signal = aligned_mat(end-size_right_samples:end,:,:); %Get the right side of the signal
left_time = aligned_time(1:size_left_samples);%Get the left side of the time
right_time = aligned_time(end-size_right_samples:end);%Get the right side of the time
end

