function factor_graph()

global fg value_number;

%-----------------------------------------------------------------------
%syntax: you need to specify nodes (Nodes.Name) and their connecting edges 
%using the s,t representation 
s={'x' 'x' 'k' 'k' 'y' 'y'};
t={'XOR1' 'Kx' 'XOR1' 'Lk' 'XOR1' 'Ly'};

%syntax: specify what every node represents (Nodes.Type)
%variable nodes of factor graph
var_node={'x' 'k' 'y'};
%leakage nodes of factor graph
leak_node={'Lk' 'Ly'};
%knowledge nodes of factor graph
know_node={'Kx'};

%operator nodes of factor graph
op_node={'XOR1'};
%using the same order as the op_node, specify the IO of operators (Nodes.Input, Nodes.Output)
input_op_node={{'x' 'k'}}; %i.e. XOR1 has input x and k
output_op_node={{'y'}};% i.e. XOR1 has output y
%using the same order as the op_node, specify the operator type (Nodes.OpType)
op_type={'xor21'};




%-----------------------------------------------------------------------


%create factor graph
fg = graph(s,t);

%Create custom attribute types for variable/leak/known/operator nodes

%variable nodes
var_index=findnode(fg,var_node);
for i=1:length(var_index)
    fg.Nodes.Type{var_index(i)}='var';
    fg.Nodes.FactorType{var_index(i)}=[];
    %initialize marginal probabilities to 1 i.e. all are equiprobable
    fg.Nodes.Marginal{var_index(i)}=ones(1,value_number);
end

%leakage nodes
leak_index=findnode(fg,leak_node);
for i=1:length(leak_index)
    fg.Nodes.Type{leak_index(i)}='factor';
    fg.Nodes.FactorType{leak_index(i)}='leak';
end

%knowledge nodes
know_index=findnode(fg,know_node);
for i=1:length(know_index)
    fg.Nodes.Type{know_index(i)}='factor';
    fg.Nodes.FactorType{know_index(i)}='know';
end

%operator nodes
op_index=findnode(fg,op_node);
for i=1:length(op_index)
    fg.Nodes.Type{op_index(i)}='factor';
    fg.Nodes.FactorType{op_index(i)}='op';
    %set the IO for the operator node
    fg.Nodes.Input{op_index(i)}=input_op_node{i};
    fg.Nodes.Output{op_index(i)}=output_op_node{i};
    %set the operator type
    fg.Nodes.OpType{op_index(i)}=op_type{i};
end

%initialize all nodes with equiprobable messages
all_index=findnode(fg,fg.Nodes.Name);
for i=1:length(all_index)
    for j=1:length(all_index)
        fg.Nodes.Message{i,j}=ones(1,value_number);
    end
end

%initialize attack valeus/traces/template fields 
leak_index=findnode(fg,leak_node);
for i=1:length(leak_index)
    fg.Nodes.AttackValues{leak_index(i)}=[]; 
    fg.Nodes.AttackTraces{leak_index(i)}=[]; 
    fg.Nodes.TemplateMean{leak_index(i)}=[];  
    fg.Nodes.TemplateStd{leak_index(i)}=[];  
end


   

end