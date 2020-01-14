% The core BP function, performing the message creation and the 
% message passing in the factor graph. The messages are stored in the graph
% edges

function [aggregated_secret_probability, correct_secret_found, secret_rank] = belief_propagation(current_no_attack_traces)

global spec fg;


% initialize aggregated secret probabilities 
aggregated_secret_probability = ones(1, 2^spec.SizeDict(spec.SecretVar));

% find index of secret variable
secret_index = find(strcmp(fg.Nodes.Name, spec.SecretVar));

% get all leakage factors
leak_index = findnode(fg, spec.LeakNode);
% get all knowledge factors
know_index = findnode(fg, spec.KnowNode);
% list all the indexes together
leak_know_index = [leak_index' know_index'];
% get all variable nodes
var_index = findnode(fg, spec.VarNode);
% get all factor nodes
factor_index = find(strcmp(fg.Nodes.Type, 'factor'));



% Given a BP attack using current_no_attack_traces, we aggregate them
for trace_index = 1:current_no_attack_traces


% Initialize all message edges with equiprobable messages
var_index = findnode(fg, spec.VarNode);
[s ,t] = findedge(fg);
for i=1:length(s)
    current_s = s(i);
    current_t = t(i);
    
    % find the variable and the factor of this edge
    if ismember(current_s, var_index)
        var_name = fg.Nodes.Name{current_s};
        factor_name = fg.Nodes.Name{current_t};
    else
        var_name = fg.Nodes.Name{current_t};
        factor_name = fg.Nodes.Name{current_s};
    end
    
    fg.Edges.R{i} = ones(1, 2^spec.SizeDict(var_name));
    fg.Edges.Q{i} = ones(1, 2^spec.SizeDict(var_name));
    
end % end of message initialization


% BP initial step

% Initial messages from leakage/knowledge nodes to variable nodes


% for every leakage and knowledge factor node send a message to the 
% neighbouring variable nodes
for i=1:length(leak_know_index)
    
    % select a leakage or knowledge factor node
    current_factor_index = leak_know_index(i);
    current_factor_name = fg.Nodes.Name{current_factor_index};
    
    % find all its neighbouring variable nodes
    % thus if the leakage node has multiple variables connected to it, it
    % propagates messages to all
    hood_indexes = neighbors(fg, current_factor_index);
    for j=1:length(hood_indexes)
        
        current_var_index = hood_indexes(j);
        current_var_name = fg.Nodes.Name{current_var_index};
        
        % compute the message for the leakage factor
        message = compute_factor_message(current_factor_name, current_var_name, [], [], trace_index, current_no_attack_traces);
        
        % send the message from the leakage factor to the variable
        current_edge = fg.findedge(current_factor_index, current_var_index);
        fg.Edges.R{current_edge} = message;
     
    end
end % end of BP initial step



% BP full message passing

% start of BP iterations
for iteration=1:spec.NoBPIterations

    % for every variable node in the graph send messages to all its 
    % neighbouring factor nodes  
    for i=1:length(var_index)
        % select a var node
        current_var_index = var_index(i);
        current_var_name = fg.Nodes.Name{var_index(i)};
        
        % find all its neighbouring factor nodes
        hood_indexes = neighbors(fg, current_var_index);
        
        for j=1:length(hood_indexes)
            % select the factor node
            current_factor_index = hood_indexes(j);
            current_factor_name = fg.Nodes.Name{current_factor_index};
            % create message for current_factor_node. To do this use messages
            % stored in all neighboring factor nodes of current_var_index,
            % except for the factor node current_factor_index
            message_creation_factors_indexes = setdiff(hood_indexes, current_factor_index);
                      
            % compute the message
            compute_var_message(current_var_name, message_creation_factors_indexes);
            
            target_edge = fg.findedge(current_factor_index, current_var_index);
            fg.Edges.Q{target_edge} = message;
        end
    end
    
    % for every factor node in the graph, send messages to all its 
    % neighbouring variable nodes  
    for i=1:length(factor_index)
        
        current_factor_index = factor_index(i);
        current_factor_name = fg.Nodes.Name{current_factor_index};
        
        %find all its neighbouring variable nodes
        hood_indexes = neighbors(fg, current_factor_index);
        
        for j=1:length(hood_indexes)
            
            % select the variable index
            current_var_index = hood_indexes(j);       
            current_var_name = fg.Nodes.Name{current_var_index};
            
            message_creation_vars_names = [];
            messages_needed = [];
            
            % operator factor case
            if strcmp(fg.Nodes.FactorType{current_factor_index}, 'op')
                % to create message to current_var_index, use the the 
                % whole neibourhood of current_factor_index, 
                % excluding the current_var_index
                message_creation_vars_indexes = setdiff(hood_indexes, current_var_index);
                % create list of all variables and corresponding messages that
                % will be used to build a new message
                counter = 1;
                
                for k = message_creation_vars_indexes'

                    % find all variables involved in message creation
                    message_creation_vars_names{counter} =  fg.Nodes.Name{k};

                    % find the correspondig messages involved 
                    message_edge = fg.findedge(k, current_factor_index);
                    partial_message = fg.Edges.Q{message_edge};
                    messages_needed{counter} = partial_message;

                    counter = counter + 1;
                end
            end
            
            % message computation
            message = compute_factor_message(current_factor_name,...
                                            current_var_name, ...
                                            message_creation_vars_names,...
                                            messages_needed,...
                                            trace_index, ...
                                            current_no_attack_traces);
                                        
            
            
            target_edge = fg.findedge(current_factor_index, current_var_index);
            fg.Edges.R{target_edge} = message;
            
        end
        
    end

end % end of BP full step


% Marginalization
% for every variable node use all its neigbouring factor nodes to compute
% its marginal
for i=1:length(var_index)
    
    %select current var node
    current_var_index = var_index(i);
    current_var_name = fg.Nodes.Name{var_index(i)};
    
    %find all its neighbouring factor nodes
    hood_indexes = neighbors(fg, current_var_index);
    
    for j=1:length(hood_indexes)
        current_factor_index = hood_indexes(j);
        target_edge = fg.findedge(current_factor_index, current_var_index);
        current_message = fg.Edges.R{target_edge};
        
        % probability product
        fg.Nodes.Marginal{current_var_index} = fg.Nodes.Marginal{current_var_index} .* current_message;
        % normalize
        fg.Nodes.Marginal{current_var_index} = fg.Nodes.Marginal{current_var_index} / sum(fg.Nodes.Marginal{current_var_index});
    end
    
end % end of marginalization loop

% find the probability distribution of the variable node that contains the
% secret variable that we target
secret_probability = fg.Nodes.Marginal{secret_index};
% perform probability aggregation over multiple attack traces
aggregated_secret_probability = aggregated_secret_probability .* secret_probability;
% normalize aggregated probability
aggregated_secret_probability = aggregated_secret_probability / sum(aggregated_secret_probability);


end % end of attack traces loop


% compute rank of the correct key and the success rate of the SASCA attack
[values, indexes] = sort(aggregated_secret_probability, 'descend');
value_recovered = indexes(1) - 1;
correct_secret_found = spec.SecretValue == value_recovered;
secret_rank = find(indexes - 1 == spec.SecretValue);


end % end of function

