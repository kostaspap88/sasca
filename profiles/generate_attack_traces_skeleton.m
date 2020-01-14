% This function updates the factor graph with the attack values and the 
% attack traces, by simulating the a leakage model

% -> this function has to match with specify_profile_<technique> and
% compute_probability_<technique>

function generate_attack_traces_skeleton()


global fg spec;

%for all leakage nodes
leak_index = findnode(fg, spec.LeakNode);
for i=leak_index'
%      fg.Nodes.AttackTraces{i} = func(fg.Nodes.AttackValues{i}(:) , other parameters)
end


end