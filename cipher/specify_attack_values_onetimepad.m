% This function simulates the attack values of the one time pad cipher and
% assigns them to graph leakage and knowledge factor nodes

function specify_attack_values_onetimepad()


global spec fg;

% random input (known during attack)
x = randi(2^spec.SizeDict('x'), 1, spec.NoAttackTraces) - 1;
% fixed key k (unknown during attack)
k = spec.SecretValue * ones(1,  spec.NoAttackTraces); 
% random value y = x XOR k
y = bitxor(x, k); 

% assign the attack values to the knowledge/leakage factor nodes
fg.Nodes.AttackValues{findnode(fg, 'Kx')} = x;
fg.Nodes.AttackValues{findnode(fg, 'Lk')} = k;
fg.Nodes.AttackValues{findnode(fg, 'Ly')} = y;

end