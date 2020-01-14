% This function specifies univariate Gaussian profiling
% In particular it uses the template mean and standard deviation. This 
% default version uses the ID leakage model and the current noise level

function specify_profile_idunivgauss()


global fg spec

% find all leak factor nodes in graph
leak_index = findnode(fg, spec.LeakNode);

% initialize template matrices
mu = cell(length(leak_index),1);
sigma = cell(length(leak_index),1);

% the template follows the identity leakage model for every leakage node
for i=1:length(leak_index)
    
    % find in which variable node this leakage node is attached
    hood_indexes = neighbors(fg, leak_index(i));
    
    % everything attached to a variable node should have the same bitsize
    % in its messages. Thus we pick the 1st thing attached to this variable
    % node to find the message size in bits.
    bitsize = spec.SizeDict(fg.Nodes.Name{hood_indexes(1)});
    
    
    no_classes = 2^bitsize;
    for j=1:no_classes
        mu{i}(j) = j-1;
        sigma{i}(j) = spec.NoiseSigma;
    end  
end

% update the leakage nodes of the factor graph with mean and std storing it
% at fg.Nodes.Profiles
for i=1:length(leak_index)
    fg.Nodes.Profiles{leak_index(i)} = {mu{i} sigma{i}};
end


end