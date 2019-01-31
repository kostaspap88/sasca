%this fucntion specifies the template mean and standard deviation. This 
%default version uses the ID leakage model and %the current noise level
%specified in config.m
%->you can provide specific templates for intermediate values or use 
%estimated mean and std. 

function specify_templates()

global fg value_number noise_sigma templates

%find all leak factor nodes in graph
leak_index=find(strcmp(fg.Nodes.FactorType,'leak'));


%initialize template matrices
mu=cell(length(leak_index),1);
sigma=cell(length(leak_index),1);

%the template follows the identity leakage model for every leakage node
for i=1:length(leak_index)
    for j=1:value_number
        mu{i}(j)=j-1;
        sigma{i}(j)=noise_sigma;
    end
    
end

%store mean and std globally
templates.mu=mu;
templates.sigma=sigma;

%update the leakage nodes of the factor graph with mean and std
for i=1:length(leak_index)
    fg.Nodes.TemplateMean{leak_index(i)} = mu{i};
    fg.Nodes.TemplateStd{leak_index(i)}= sigma{i}; 
end


end