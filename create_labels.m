function [label_vector, synthetic_signal] = create_labels(negative_size, positive_size, length, fp, fn, negativ_amp, positive_amp, sr)
%CREATE_LABELS generates a vector of a set length. the set is synthetic
%data, where the negative example is a freqeuncy set as fn and the positive
%is a frequency set at fp.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%negative_size: Is the size in seconds of the times with no squeeze
%positive_size: Is the size in seconds of the duration of the squeeze
%length: Is the duration in seconds of the whole run
%fp: Is the desired frequency for the moments with squeeze
%fn: Is the desired frequency with the momoents with no squeeze
%sr: Desired sampling rate for the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Outputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%label_vector: vector of 1s and 0s for the squeeze and non squeeze
%frequency_vector: vector with the desired frequencies.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%First we generate the desired labels.
%which is a square wave with controlled duty cycle
length_in_samples = length * sr; %get the length in samples of the vector
time_vector = [1:length_in_samples]/sr; %get the time vector
%calculate the duty cycles
duty_cycle = positive_size/(positive_size + negative_size)*100;
frequency_labels = 1/(positive_size+negative_size);%The frequency of the labels is just the sum of the durations
label_vector = square(2*pi*frequency_labels*time_vector, duty_cycle);%use the square to get the square wave
%we need to rescale the wave
label_vector = (label_vector + 1)/2;
inverted_label = -(label_vector - 1);%now we get an inverted set of labels to obatin our frequency vector
positive_signal = positive_amp*sin(2*pi*fp*time_vector); %get our positive signal
negative_signal = negativ_amp*sin(2*pi*fn*time_vector); %get our negative signal
positive_signal = positive_signal.*label_vector; %mask the positive signal using the labels
negative_signal = negative_signal.*inverted_label; %mask the negative signal using the inverted labels
synthetic_signal = positive_signal + negative_signal;




end

