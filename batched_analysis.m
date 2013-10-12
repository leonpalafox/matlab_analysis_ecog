%This script loads the data from the PennPrject dataset into the matlab
%environment
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set the critical variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_chan = get_variables('number_of_channels');
num_record_chan =  get_variables('number_recorded_channels');
originalSamplingRate = get_variables('Original_Sampling_Rate');
desired_samplingRate = get_variables('Desired_Sampling_Rate'); %This is the desired post decimating sampling rate
decimate_factor = originalSamplingRate/desired_samplingRate;%set the decimation factor
samplingRate = originalSamplingRate/decimate_factor; %The 25000 is hardcoded to the sampling rate we used to do the data capture.
window_size = 0.300; %size of the window in seconds
window_size = window_size * samplingRate; %transform the window size to samples
size_of_batch = 150; %size of the batch in seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read the data files
root_path = ['/home/leon/Data/Penn/Oct_1'];
time_stamps_file = [root_path '/data_click_Tue_01.10.2013_10:12:28'];
data_file = [root_path '/data_Tue_01.10.2013_10:12:24'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Given the batch size and the sampling rate we calculate the number of
%batches to iterate over
num_4_byte_column = 4+num_record_chan; %number of columns that have 4 bytes 
dinfo = dir(data_file); %get the information of the data file
num_rows = dinfo.bytes/(8+num_4_byte_column*4);% we need to divide the total amount of bytes by the amount of bytes per row.
%The amount of bytes per row depends on the data format
total_time = num_rows/originalSamplingRate;%calculate the total time of captured data
batch_size_samples = floor((size_of_batch/total_time)*num_rows);%calculate the number of samples that correspond to the desired size
%calculate the maximum number of batches
max_num_batches = ceil(total_time/size_of_batch);
%finsih reading data files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create place holders where 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

large_power_matrix = [];
large_labels = [];
%Start the batched analysis
for batch_idx = 1:max_num_batches
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    channels_data = return_batch(data_file, size_of_batch, originalSamplingRate, 2, 'eeg');
    force = return_batch(data_file, size_of_batch, originalSamplingRate, 1, 'force');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %pre process data files (trim, decimate)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    x=decimate(channels_data(:,1), decimate_factor);%set a decimation on the first channel to get the value of the matrix
    force = decimate(force, decimate_factor);
    channels_data_dec = zeros(size(x,1), num_chan);%generate matrix for speed purposes
    for chidx=2:num_chan
        channels_data_dec(:,chidx) = decimate(channels_data(:,chidx), decimate_factor); %do the decimation of the data
    end
    channels_data = channels_data_dec;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %clean the workspace to free up memory
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    clear x;
    clear channels_data_dec;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mean_data = repmat(mean(channels_data,2),1,num_chan);%obtain the mean and repeat it over the number of channels for the later operation.
    channels_data=channels_data-mean_data; %rest the mean to normalize

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
    large_power_matrix = [large_power_matrix; power_matrix];
    large_labels = [large_labels; labels];
end

toc
break

[b,dev,stats] = glmfit(large_power_matrix ,large_labels,'binomial','logit'); % Logistic regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Plotting Section
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
perc_graph = 0.1; %this controls the major ticks of the plot to every 10% of the total

imagesc(reshape(b(2:end),num_chan, size(F,1)))%generates a heat map with x axis as the frequency and y as the channel
colorbar;
set(gca,'XTick',[1:floor(size(F,1)*perc_graph):size(F,1)]);% shows ticks for every bin
set(gca,'YTick',[1:num_chan]);% limits the ticks for the channels
set(gca,'XTickLabel',F(1:floor(size(F,1)*perc_graph):end)); %set the ticks to be the center frequency
set(gca,'XMinorTick','on'); %set the minor ticks on
xlabel('Frequency[Hz]')
ylabel('Channel')
toc
 
