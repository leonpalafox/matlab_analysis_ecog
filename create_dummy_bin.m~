%create binary file that has the same format as the data file of the 
%Penn experiments
samp_rate = 25000;%define sampling rate of the new signal in Hz
freq_to_simulate = 100; %in Hz
num_channels = 60;%use an even number of channels; define the number of channels; first half will have signal, second half will not
time_duration = 30; %duration of the signal in seconds.
signal_amplitude = 1; %arbitrary signal units; same for all channels with signal
noise_standard_dev = 1; %arbitrary signal units; same for all channels; all channels have zero-mean noise

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ntp = samp_rate*time_duration;%get the number of samples
time_axis = [1:ntp]/samp_rate;%get the time vector
labels = sin(2*pi*0.25*time_axis);%get the labels based on a cosine
labels = labelize(labels+1, 0.5);% clamp to only positive values of the cosine
%signal = chirp(time_axis, 100,10,200,'quadratic');%generate a frequency sweep
signal = sin(2*pi*freq_to_simulate*time_axis);%get the labels based on a cosine
signal = ammod(signal, 0.125, samp_rate);%modulate the signal using the labels
signal = repmat(signal,floor(num_channels/2),1)';%copy over 16 channels
signal = [signal zeros(size(signal))];
signal_and_noise = signal + normrnd(0,noise_standard_dev,size(signal)); %signal plus noise
%now I create dummy cloumns to complyu with the same data format that
%Mosalam has
dummy_force = repmat(labels,4,1)'; %labels variable refers to the simulated force data.
                                    %this line just fills out the first 4
                                    %data columns with the same force data
                                    %to conform with expected data format

%now we iterate to generate the bin file
fid=fopen('dummy.bin','w');%open the file
fseek(fid,0,'bof');%go to the beginning of the file
for writing_idx=1:ntp
    fwrite(fid,time_axis(writing_idx),'uint64');
    fwrite(fid,dummy_force(writing_idx,:), 'float');
    fwrite(fid, signal_and_noise(writing_idx,:), 'float');
end
fclose(fid);
    







