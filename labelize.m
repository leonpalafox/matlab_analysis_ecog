function [labels] = labelize(force, threshold)
%Function to obtaion discrete labels from the force sensors
%   input:
%   force: raw data from the force sensor
%   threshold: threshold to determine when a data point is considered a one
[ntp, dim] = size(force);
labels = zeros(ntp, dim); %generate the placeholder array
labels(force>=threshold) = 1;
end

