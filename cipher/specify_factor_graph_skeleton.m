% This function specifies the factor graph of a custom cipher

% input: user-defined graph structure
% output: factor graph specification stored in spec

function specify_factor_graph_skeleton()


global spec

% specify nodes (will be stored as Nodes.Name) and their connecting edges 
% using the s-t representation. 
% spec.S = {};
% spec.T = {};

% specify what every node represents (will be stored as Nodes.Type)
% variable nodes of factor graph
% spec.VarNode = {};
% using the same order as the spec.VarNode, specify the variable size in
% bits
% spec.VarSize = {};
% leakage nodes of factor graph
% spec.LeakNode = {};

% knowledge nodes of factor graph
% spec.KnowNode = {};



% operator nodes of factor graph
% spec.OpNode = {};
% using the same order as in the spec.OpNode, specify the operator type
% spec.OpType = {};
% using the same order as in the spec.OpNode, specify the inputs and
% outputs of every operator
% spec.OpInput = {};
% spec.OpOutput = {};


% create a map that contains the correct type for every op_node
% spec.OpTypeDict = containers.Map(spec.OpNode, spec.OpType);
% create a map that contains the correct input(s) for every op_node
% spec.OpInputDict = containers.Map(spec.OpNode, spec.OpInput);
% create a map that contains the correct output(s) for every op_node
% spec.OpOutputDict = containers.Map(spec.OpNode, spec.OpOutput);

% create a map that has the bit size of every variable
% spec.SizeDict = containers.Map([spec.VarNode], ...
%                             [spec.VarSize]);


% specify which leakage and knowledge nodes are constant values and which
% leakage/knowledge nodes are random in every cipher execution
% spec.ConstantFactors = {};
% spec.RandomFactors = {};

% specify which variable node in the graph is the key
% spec.SecretVar = ;
% specify the value of the secret variable node
% spec.SecretValue = ;


end
