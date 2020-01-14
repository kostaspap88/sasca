% This function specifies the factor graph of the one time pad cipher

% input: user-defined graph structure
% output: factor graph specification stored in spec

function specify_factor_graph_onetimepad()


global spec

% specify nodes (will be stored as Nodes.Name) and their connecting edges 
% using the s-t representation. 
spec.S = {'x' 'Kx' 'k' 'Lk' 'XOR1' 'Ly'};
spec.T = {'XOR1' 'x' 'XOR1' 'k' 'y' 'y'};

% specify what every node represents (will be stored as Nodes.Type)
% variable nodes of factor graph
spec.VarNode = {'x' 'k' 'y'};

% using the same order as the spec.VarNode, specify the variable size in
% bits
spec.VarSize = {2, 2, 2};
% create a map that has the bit size of every variable
spec.SizeDict = containers.Map([spec.VarNode], ...
                            [spec.VarSize]);
                        
% leakage nodes of factor graph
spec.LeakNode = {'Lk' 'Ly'};

% knowledge nodes of factor graph
spec.KnowNode = {'Kx'};

% operator nodes of factor graph
spec.OpNode = {'XOR1'};

% using the same order as in the spec.OpNode, specify the operator type
spec.OpType = {'xor21'};
% create a map that contains the correct type for every operator node
spec.OpTypeDict = containers.Map(spec.OpNode, spec.OpType);

% using the same order as in the spec.OpNode, specify the inputs and
% outputs of every operator
spec.OpInput = {{'x' 'k'}};
spec.OpOutput = {{'y'}};
% create a map that contains the correct input(s) for every operator node
spec.OpInputDict = containers.Map(spec.OpNode, spec.OpInput);
% create a map that contains the correct output(s) for every operator node
spec.OpOutputDict = containers.Map(spec.OpNode, spec.OpOutput);

% specify which leakage and knowledge nodes are constant values and which
% leakage/knowledge nodes are random in every cipher execution
spec.ConstantFactors = {'Lk'};
spec.RandomFactors = {'Kx' 'Ly'};

% specify which variable node in the graph is the key
spec.SecretVar = 'k';
% specify the value of the secret variable node
spec.SecretValue = 3;


end
