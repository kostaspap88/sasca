% This function specifies an empty node profiling technique. 

% -> this function has to match with generate_attack_traces_<technique> and
% compute_probability_<technique>

function specify_profile_skeleton()


global fg spec

% find all leakage factor nodes in graph
leak_index = findnode(fg, spec.LeakNode);


% specify your profiling technique here
% ......

% store the profiles in the graph
for i=1:length(leak_index)
  % fg.Nodes.Profiles{leak_index(i)} = { };
end


end