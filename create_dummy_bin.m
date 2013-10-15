%create binary file that has the same format as the data file of the 
%Penn experiments
samp_rate = 25000;%define sampling rate of the new signal
num_channels = 16;%define the number of channels
time_duration = 30; %duration of the signal in seconds.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ntp = samp_rate*time_duration;%get the number of samples
time_axis = [1:ntp]/samp_rate;%get the time vector
labels = sin(2*pi*1*time_axis);%get the labels based on a cosine
labels = labelize(labels+1, 0.5);% clamp to only positive values of the cosine
%signal = chirp(time_axis, 100,10,200,'quadratic');%generate a frequency sweep
signal = sin(2*pi*100*time_axis);%get the labels based on a cosine
signal = repmat(signal,num_channels,1)';%copy over 16 channels
%now I create dummy cloumns to complyu with the same data format that
%Mosalam has
dummy_force = repmat(labels,4,1)';

%now we iterate to generate the bin file
fid=fopen('dummy.bin','w');%open the file
fseek(fid,0,'bof');%go to the beginning of the file
for writing_idx=1:ntp
    fwrite(fid,time_axis(writing_idx),'uint64');
    fwrite(fid,dummy_force(writing_idx,:), 'float');
    fwrite(fid, signal(writing_idx,:), 'float');
end
fclose(fid);
    







