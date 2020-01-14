% message computation

function message = compute_factor_message(factor_name,...
                                          var_name, ...
                                          message_vars_names,...
                                          messages,...
                                          trace_index,...
                                          current_no_attack_traces)   

global fg spec

% collect the factor node index, factor type and operator type
factor_index = fg.findnode(factor_name);
factor_type = fg.Nodes.FactorType{factor_index};
op_type = fg.Nodes.OpType{factor_index};

% Operator factor interface
if strcmp(factor_type, 'op')

    if strcmp(op_type, 'xor21')
        message = compute_factor_message_xor21(factor_name, var_name, message_vars_names, messages);
    end

    % -> interface extension1
    % if strcmp(op_type, 'your_operator_here')
    %     compute_factor_message_<yourOperatorHere>(factor_name, var_name, message_vars_names, messages)
    % end
    
end

% Leakage factor
if strcmp(factor_type, 'leak')
    
    % compute the probability
    message = compute_probability(factor_index, trace_index, current_no_attack_traces);
     
end

% Knowledge factor
if strcmp(factor_type, 'know')
    
    % initialize knowledge message to zeros
    message = zeros(1, 2^spec.SizeDict(var_name));
    % Use the trace index to set the value of knowledge factors
    attack_value = fg.Nodes.AttackValues{factor_index}(trace_index);
    message(attack_value + 1) = 1;
    % no need for normalization
    
end



end