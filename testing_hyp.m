function [hyp_values] = testing_hyp(coeff);
%TESTING_HYP  checsks the hypotesis validation of valuesw being zero or not
%for the coefficients b
%   input:
%   b: coefficients result from a regression
%output:
%   hyp_values: the hypotesis values of the regression
hyp_values = zeros(size(coeff)); %generate a balnk zero for the hypotesis
hyp_values(abs(coeff)>0.1) = 1;
end

