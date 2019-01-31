%this function computes the template mean and standard deviation of
%intermediate values used in SASCA. Uses the real dataset

function [testset mu sigma]=template_dataset()

global value_number trace_filename train_ratio test_ratio;
mu=zeros(value_number,1);
sigma=zeros(value_number,1);

%import dataset
%FILE OPERATIONS HERE

%partition to train and test sets

%compute mean/std for the range of the intermediate value
for i=1:value_number
       %mu(i)
       %sigma(i)
end


end