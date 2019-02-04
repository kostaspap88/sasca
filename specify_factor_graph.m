%this function describes the structure of the factor graph.
%->you need to specify the graph nodes, edges, type of nodes, types of
%operator nodes, IO of operator nodes, name of the secret variable (e.g.
%key under attack)

function specify_factor_graph()


global fg_spec secret_name;

%specify nodes (will be stored asNodes.Name) and their connecting edges 
%using the s,t representation 
s={'x' 'x' 'k' 'k' 'y' 'y'};
t={'XOR1' 'Kx' 'XOR1' 'Lk' 'XOR1' 'Ly'};

%specify what every node represents (will be stored as Nodes.FactorType)
%variable nodes of factor graph
var_node={'x' 'k' 'y'};
%leakage nodes of factor graph
leak_node={'Lk' 'Ly'};
%knowledge nodes of factor graph
know_node={'Kx'};
%operator nodes of factor graph
op_node={'XOR1'};

%using the same order as the op_node, specify the IO of operators (stored as Nodes.Input, Nodes.Output)
input_op_node={{'x' 'k'}}; %i.e. XOR1 has input x and k
output_op_node={{'y'}}; % i.e. XOR1 has output y
%using the same order as the op_node, specify the operator type (stored as Nodes.OpType)
op_type={'xor21'}; %i.e. XOR1 is a xor21 operator

%specify which factor in the graph is the key
secret_name='k';

%specify which leakage and knowledge nodes are constant and which are
%random 
constant_factors={'Lk'};
random_factors={'Kx','Ly'};
%random_factors={};

%store the user specification globally in fg_spec
fg_spec.S=s;
fg_spec.T=t;
fg_spec.VarNode=var_node;
fg_spec.LeakNode=leak_node;
fg_spec.KnowNode=know_node;
fg_spec.OpNode=op_node;
fg_spec.InputOpNode=input_op_node;
fg_spec.OutputOpNode=output_op_node;
fg_spec.OpType=op_type;
fg_spec.ConstantFactors=constant_factors;
fg_spec.RandomFactors=random_factors;



