%This script loads the data from the PennPrject dataset into the matlab
%environment
clear
tic
root_path = ['/home/leon/Data/Penn/Oct_1'];
time_stamps_file = [root_path '/data_click_Tue_01.10.2013_10:12:28'];
data_file = [root_path '/data_Tue_01.10.2013_10:12:24'];
num_chan = 16;
fid = fopen(time_stamps_file,'r');
%read first column
fseek(fid, 0, 'bof'); 
clickTime = fread(fid, Inf, '*uint64', 4);
%read second column
fseek(fid, 8, 'bof'); 
hand = fread(fid, Inf, '*int', 8);
%%%%%%%reading the other file
fid = fopen(data_file,'r');
fseek(fid, 8, 'bof');
force = fread(fid, Inf, 'float', 8+4*19);
%reading of all the chanels
%first we read one of the channels to create the matrix
fseek(fid, 8+4*4, 'bof');
ch1 = fread(fid, Inf, 'float', 4*19+8);
channels_data = zeros(size(ch1,1), num_chan);
channels_data(:,1) = ch1;
clear ch1; %remove ch1 from the workspace to free up memory
%now loop through all the channels to populate the data file
for chidx=2:num_chan
    channel_offset = 3+chidx; %channel ofsset is the offset to move in the binary file
    fseek(fid, 8+channel_offset*4, 'bof');%fseek moves the pointer over the binary file
    channels_data (:,chidx) = fread(fid, Inf, 'float', 4*19+8);%copy everything to the pre created array
end
fclose(fid);
channels_data = channels_data(clickTime(1):clickTime(10),:);%grab segments between click to ensure the data is clean
force = force(clickTime(1):clickTime(10),:);
decimate_factor = 5;%set the decimation factor
x=decimate(channels_data(:,1), decimate_factor);%set a decimation on the first channel to get the value of the matrix
force = decimate(force, decimate_factor);
channels_data_dec = zeros(size(x,1), num_chan);%generate matrix for speed purposes
for chidx=2:num_chan
    channels_data_dec(:,chidx) = decimate(channels_data(:,chidx), decimate_factor); %do the decimation of the data
end
channels_data = channels_data_dec;
%clean the workspace to free up memory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
clear x;
clear channels_data_dec;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mean_data = repmat(mean(channels_data,2),1,num_chan);%obtain the mean and repeat it over the number of channels for the later operation.
channels_data=channels_data-mean_data; %rest the mean to normalize
samplingRate = 25000/decimate_factor; %The 25000 is hardcoded to the sampling rate we used to do the data capture.
window_size = 0.300; %size of the window in seconds
window_size = window_size * samplingRate; %transform the window size to samples
%calculate the spectrogram for the first channel to generate the matrix
[S,F,T,P] = spectrogram(channels_data(:,1), hann(window_size), 0, window_size, samplingRate);
[power_p, time_p] = size(P);
power_matrix = zeros(time_p, power_p * num_chan); %generate the nameholder matrix for the pwoers
power_matrix(:,1:power_p) = P'; %allocate the powers from the first channels
for chidx = 2:num_chan
    [S,F,T,P] = spectrogram(channels_data(:,chidx), hann(window_size), 0, window_size, samplingRate);  %transform the channel
    pow_idx = (chidx-1)*power_p+1;
    power_matrix(:,pow_idx:chidx*power_p) = P'; %allocate the powers from the channels
end
%code to match the force sensors with the spectrogram data
time_axis = (1:size(force,1))/samplingRate;%generate the time series of the force
[TF, match_idx] = findNearest(T,time_axis); %is member looks up which indexes match the output from the 
force = force(match_idx,1);%recapture the force using the matched indexes
force_threshold = 0.2;
labels = labelize(force, force_threshold);
[b,dev,stats] = glmfit(power_matrix ,labels,'binomial','logit'); % Logistic regression
imagesc(reshape(b(2:end),num_chan, size(F,1)))%generates a heat map with x axis as the frequency and y as the channel
colorbar;
set(gca,'XTick',[1:size(F,1)]);% shows ticks for every bin
set(gca,'YTick',[1:num_chan]);% limits the ticks for the channels
set(gca,'XTickLabel',F); %set the ticks to be the center frequency
xlabel('Frequency[Hz]')
ylabel('Channel')
toc
 
