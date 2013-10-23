function [Time_Axis, Channel_Data] = load_channel_data(filename)
%LOAD_CHANNEL_DATA loads the wholse set of channels from a given file in
%biosemi format.
%It uses the functions ImportBDFHeader_Bryan, which is a modified version
%of ImportBDFHeader implemented by Bryan He, the changes are very few and
%both functions work to extract the metadata of the biosemi file, like the
%sampling rate and number of channels.
%It also uses the mex file ChannelReaderBDF, both this functions are
%located in http://www.biosemi.com/download.htm, and more specifically is
%the http://www.biosemi.com/download/bdf_reader_matlab_scholte.zip link.
%Installation:
%The downloaded file has a C file that needs to be compiled using the
%instruction:
%mex ChannelReaderBDF.c
%The headers of the C file need to be directed to the place where mex.h and
%matrix.h are located. Under Ubuntu 12.4, is enough to write 
%include "matrix.h"
%include "mex.h"
%Under windows it could be in a different direction/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT:
%--------------------------------------------------------------------------
%filename:Filename with the biosemi data file location
%--------------------------------------------------------------------------
%OUTPUT:
%--------------------------------------------------------------------------
%Time_Axis = Time Data corresponding to the data, it uses the sampling rate
%recorded in the biosemi file.
%Channel_Data = Data of the EEG Channels in the same column order of the format of
%the data is, if the documentation of the file mentions channel 1, it will
%be column 1 in Channel_Data
%(C) L.Palafox 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This part of the codes removes the extension, because the ImportBDFHeader
%file only uses the filename without the extension.
[pathstr, name, ext] = fileparts(filename); %parse the filename to get its extension
if ~all(ext == '.bdf') %if the file is not a biosemi file
    error('The input file is not in the biosemi format') %output error message
end
fname = [pathstr '/' name]; %join only the path but not the extension
data = ImportBDFHeader_Bryan(fname); %get the metadata of the biosemi file
%It is a data structure.
sizeHeader = 256 + 256 * data.channels; %set a header for the read of the data format.
%This apparently is a default format for biosemi
%here we get the memory information of where is the end of the file by
%opening the file and 
fid = fopen(filename, 'r');%open the file for reading
fseek(fid,0,'eof');%locate the pointer at the beginning of the file
endOfFile = ftell(fid);%saves to pointer pf the fcurrent position of the file
fclose(fid);%close the file
%To create the holding matrix, we use two of the data structure properties,
%which is number of samples and number of trials, we get the total number
%of data points in time by multyplying those two varibales.
total_time_samples = data.nTrials*data.nSamples;
%We can create the time vector to plot sensible results
Time_Axis = [1:total_time_samples]/data.sampleRate;
%We also create the holding matrix for the channels
Channel_Data = zeros(total_time_samples, data.channels);
%The data is organized by columns.
%Now we iterate to fill up the matrix
for channel_idx = 1:data.channels
    currentChannel = ChannelReaderBDF(filename,data.channels,data.nSamples,data.nTrials,channel_idx,data.sampleRate,endOfFile,sizeHeader)';
    %This line gets the channel using the compiled C file, by changing the
    %variable channel_idx, we can change the channel to read.
    %If the channels have been exceded, it throws an error.
    %Is recommendable to read the data.channels variable to see to which extent
    %can we read channels
    %We need to multiply any gain that the sensor might have had
    currentChannel = currentChannel*data.sensor.gain(channel_idx);
    Channel_Data(:,channel_idx) = currentChannel; %We allocate the values in the matrix
end

    
    