function [freq_array] = extract_frequency(spectrogram_data, frequency_array, desired_frequencies, freq_mode)
%EXTRACT_FREQUENCY extracts the averaged desired frequencies in a spectrogram given
%a frequency array output and a set of desired frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%spectrogram_data: is an array of TxF where T is time and F is the
%frequency bands
%frequency_array: Is the F vector generated from the spectrogram function
%that has the identities of each column in the spectrogram _data
%desired_frequencies: Has an array of 1xD that has the desired frequencoies
%to analyse.
%freq_mode: text variable that can be "average" if we want a single channel
%with the average of the desired frequencies or "single" if we want an
%arrayTxD, where we display the desired frequencies.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%outputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%freq_array: it can be either a Tx1 array if the freq_mode is set to
%average or a TxD array if tje freq_mode is set to mean.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%first we need to find the nearest value in the frequency array from the
%desired frequencies
    [val, near_index] = findNearest(desired_frequencies, frequency_array);
    near_index = unique(near_index); %if there are repeatede indexes, this takes care of that
    freq_array = spectrogram_data(:,near_index);%we extract only the elements of interest
    switch freq_mode
        case 'average'
            freq_array = mean(freq_array, 2);
        case 'single'
    end

end




