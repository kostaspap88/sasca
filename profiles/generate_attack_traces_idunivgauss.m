% This function updates the factor graph with the attack values and the 
% attack traces, by simulating the univariate Gauss leakage model as:
% leakage = value + N(0, spec.NoiseSigma)

function generate_attack_traces_idunivgauss()


global fg spec;

%for all leakage nodes
leak_index = findnode(fg, spec.LeakNode);
for i=leak_index'
     fg.Nodes.AttackTraces{i} = fg.Nodes.AttackValues{i}(:) + ... 
                            normrnd(0, spec.NoiseSigma, spec.NoAttackTraces, 1);
end


end