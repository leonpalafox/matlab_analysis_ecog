training_perc = 0.7;
%function output_reference_matrix(raw_data, training_perc)

%OUTPUT_REFERENCE_MATRIX takes a matrix of raw ECoG data and runs a
%regression using a reference channel as the variable to regress against.
%it then caluclates the residuals of them, to generate the transformation
%matrix.
%   Input:
%-------------------------------------------------------------------------
%   raw_data: TxD data array, where T is time and D is the number of
%   channels that were recorded in the ECoG experiment
%   training_perc: percentage of data to use to train the glmfit function
%-------------------------------------------------------------------------
%  Output
%-------------------------------------------------------------------------
%  There is no variable output, instead it writes a csv matrix, where the 1
%  row is information regarding the size of the matrix and the data starts
%  from the secnd row
%%%
reference_channel =get_variables('Reference_Channel'); %obtain reference channel from the original array
[time_samples, num_channels] = size(raw_data);
training_in_samples = floor(time_samples*training_perc); %get size of training data in samples.
training_data = raw_data(1:training_in_samples,:); %get the trinaing data
y = training_data(:,reference_channel); %get the variable to do the regression against
X = training_data(:,reference_channel+1:end);%get the x_variable
[b, dev,stats] = glmfit(X,y); %perform the regression, default is linear Gaussian (linear regression) with const 'on'



figure
numplots = 4;
subplot(numplots,1,1)
plot(X(:,1))
time = (1/300).*(1:length(y));
plot(time,X(:,1))
xlabel('Time (sec)')
ylabel('Amplitude (V)???')
title('Channel 1, raw');

subplot(numplots ,1,2);
plot(time,X(:,1)-y);
xlabel('Time (sec)')
ylabel('Amplitude (V)???')
title('Channel 1, after subtracting off the reference channel y, without scaling');

subplot(numplots,1,3);
plot(time,y);
xlabel('Time (sec)')
ylabel('Amplitude (V)???')
title('Raw y channel');


subplot(numplots,1,4);
plot(time,X(:,1)-(1/b(2)*y - b(1)/b(2)));
xlabel('Time (sec)')
ylabel('Amplitude (V)')
ylabel('Amplitude (V)???')
title('Channel 1, after subtracting off the reference channel y, using scaling provided by glmfit');
