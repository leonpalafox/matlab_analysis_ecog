function [batch_data] = return_batch( data_file, size_of_batch, samplingRate, batch_number, data_id)
%Function to return batches of the data for large datafiles.
%The data files are T X N, where T is the time and N is the different
%features
%input:
%data_file = loation of the data file to segment
%size_of_batch =  size of the desired batch in seconds
%samplingRate = sampling rate of the original non decimated signal
%batch number = decide which batch of data do you wish to extract
%data_id: defines which data you want to extract, (force or eeg).
%
%if the batch number is inconsistent with the size of the batch, and error
%will be created.
num_chan = 16;
num_4_byte_column = 4+num_chan; %number of columns that have 4 bytes 
dinfo = dir(data_file); %get the information of the data file
num_rows = dinfo.bytes/(8+num_4_byte_column*4);% we need to divide the total amount of bytes by the amount of bytes per row.
%The amount of bytes per row depends on the data format
total_time = num_rows/samplingRate;%calculate the total time of captured data
batch_size_samples = floor((size_of_batch/total_time)*num_rows);%calculate the number of samples that correspond to the desired size

%calculate the maximum number of batches
max_num_batches = floor(total_time/size_of_batch);

if batch_number > max_num_batches
    error('The requested batch is larger than the possible number of batches');
else
    
    if size_of_batch > total_time
        error('The size of batch cannot be larger than the total time');
    else
        fid = fopen(data_file,'r');
        switch data_id
            case 'eeg'
                %first we read one of the channels to create the matrix
                fseek(fid, batch_size_samples*(batch_number-1)*(8+4*num_4_byte_column)+(8+4*4), 'bof');%the second parameter of fseek indicates where we start reading
                ch1 = fread(fid, batch_size_samples, 'float', 4*(num_4_byte_column-1)+8);
                channels_data = zeros(size(ch1,1), num_chan);
                channels_data(:,1) = ch1;
                clear ch1; %remove ch1 from the workspace to free up memory
                %now loop through all the channels to populate the data file
                for chidx=2:num_chan
                    channel_offset = 3+chidx; %channel ofsset is the offset to move in the binary file
                    fseek(fid, batch_size_samples*(batch_number-1)*(8+4*num_4_byte_column)+(8+channel_offset*4), 'bof');%fseek moves the pointer over the binary file
                    channels_data (:,chidx) = fread(fid, batch_size_samples, 'float', 4*(num_4_byte_column-1)+8);%copy everything to the pre created array
                end
                batch_data = channels_data;
            case 'force'
                fid = fopen(data_file,'r');%open the file
                fseek(fid, batch_size_samples*(batch_number-1)*(8+4*num_4_byte_column)+8, 'bof');%set the pointer in the correct part of the file
                force = fread(fid, batch_size_samples, 'float', 8+4*(num_4_byte_column-1)); %read the file, and then skip, so the next read will be in the same position
                batch_data = force; %write the file in the ouput
        end
        fclose(fid);
    end
end

end

