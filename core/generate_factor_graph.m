% This function creates the factor graph object using the user-defined
% specification spec and updates/initializes all necessary fields in the
% factor graph, refered to as "fg"

% input: user-defined spec
% output: factor graph object fg

function generate_factor_graph()


global fg spec;

% Create the factor graph object using the s-t notation
% fg.Nodes.Name is set after the following operation
fg = graph(spec.S, spec.T);

% Create the Node fields of the factor graph for variable, leakage, known,
% operator nodes

% Variable nodes
var_index = findnode(fg, spec.VarNode);

for i = var_index'
    % set fg.Nodes.Type
    fg.Nodes.Type{i} = 'var';    
    % set message probabilities to 1 i.e. all values are
    % equiprobable before BP begins
    fg.Nodes.Marginal{i} = ones(1, 2^spec.SizeDict(fg.Nodes.Name{i}));
end

% Operator nodes
op_index = findnode(fg, spec.OpNode);
for i=op_index'
    % set fg.Nodes.Type
    fg.Nodes.Type{i} = 'factor';
    % set fg.Nodes.FactorType
    fg.Nodes.FactorType{i} = 'op';
    % set fg.Nodes.OpType
    fg.Nodes.OpType{i} = spec.OpTypeDict(fg.Nodes.Name{i});
end


% Leakage nodes
leak_index = findnode(fg, spec.LeakNode);
for i=leak_index'
    % set fg.Nodes.Type
    fg.Nodes.Type{i} = 'factor';
    % set fg.Nodes.FactorType
    fg.Nodes.FactorType{i} = 'leak';   
    % check if leakage factor name is constant or not and update the 
    % constant/random field accordingly
    is_constant = ismember(fg.Nodes.Name{i}, spec.ConstantFactors);
    is_random = ismember(fg.Nodes.Name{i}, spec.RandomFactors);
   
    if (is_constant == 1)
        fg.Nodes.ConstantOrRandom{i} = 'constant';
    end
    if (is_random == 1)
        fg.Nodes.ConstantOrRandom{i} = 'random';
    end
    
    % initialize the attack values, traces, and template mean/variance 
    % fields of leakage nodes
    fg.Nodes.AttackValues{i} = []; 
    fg.Nodes.AttackTraces{i} = [];  
    fg.Nodes.TemplateMean{i} = [];
    fg.Nodes.TemplateStd{i} = [];   
    
end

% Knowledge nodes
know_index = findnode(fg, spec.KnowNode);
for i=know_index'
    % set fg.Nodes.Type
    fg.Nodes.Type{i}='factor';
    % set fg.Nodes.FactorType
    fg.Nodes.FactorType{i}='know';
    
    % check if leakage factor name is constant or not and update the 
    % constant/random field accordingly
    is_constant = ismember(fg.Nodes.Name{i}, spec.ConstantFactors);
    is_random = ismember(fg.Nodes.Name{i}, spec.RandomFactors);
   
    if (is_constant == 1)
        fg.Nodes.ConstantOrRandom{i} = 'constant';
    end
    if (is_random == 1)
        fg.Nodes.ConstantOrRandom{i} = 'random';
    end
    
end

   

end