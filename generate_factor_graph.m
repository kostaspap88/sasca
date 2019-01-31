%this function creates the factor graph object. 
%->you do not need to modify this function

function generate_factor_graph()


global fg_spec fg value_number templates;

%pass the factor graph spec to this function
s=fg_spec.S;
t=fg_spec.T;
var_node=fg_spec.VarNode;
leak_node=fg_spec.LeakNode;
know_node=fg_spec.KnowNode;
op_node=fg_spec.OpNode;
input_op_node=fg_spec.InputOpNode;
output_op_node=fg_spec.OutputOpNode;
op_type=fg_spec.OpType;


%create factor graph object
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

%initialize all nodes with uniformly distributed messages
all_index=findnode(fg,fg.Nodes.Name);
for i=1:length(all_index)
    for j=1:length(all_index)
        fg.Nodes.Message{i,j}=ones(1,value_number);
    end
end

%initialize attack values/traces/template fields 
leak_index=findnode(fg,leak_node);
for i=1:length(leak_index)
    fg.Nodes.AttackValues{leak_index(i)}=[]; 
    fg.Nodes.AttackTraces{leak_index(i)}=[];  
    fg.Nodes.TemplateMean{leak_index(i)} =[];
    fg.Nodes.TemplateStd{leak_index(i)}= [];   
end


   

end