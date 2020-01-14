% message computation of the xor21 function with 2 inputs and 1 output

function message = compute_factor_message_xor21(factor_name, var_name, message_vars_names, messages)

global spec

vec1 = 0:2^spec.SizeDict(var_name)-1;
vec2 = 0:2^spec.SizeDict(message_vars_names{1})-1;
vec3 = 0:2^spec.SizeDict(message_vars_names{2})-1;
       
vector_combination = combvec(vec1, vec2, vec3);  

out1_var_name = spec.OpOutputDict(factor_name);
input_var_names = spec.OpInputDict(factor_name);
in1_var_name = input_var_names{1};
in2_var_name = input_var_names{2};

% the message output is var_name 
% the message inputs are in message_var_names{1}, message_var_names{2}
% the factor output is in out1_var_name
% the factor inpus are in in1_var_name, in2_var_name
% Now, lets find what reordering is necessary

message_order{1} = var_name;
message_order{2} = message_vars_names{1};
message_order{3} =message_vars_names{2};


% find the rotation wrt the operator IO 
out_position = find([message_order{:}] == out1_var_name{1});
in1_position = find([message_order{:}] == in1_var_name);
in2_position = find([message_order{:}] == in2_var_name);


message = zeros(1, 2^spec.SizeDict(var_name));
for i=1:length(vector_combination)
    current_vector = vector_combination(:,i);
    
    target_index = current_vector(1) + 1;
    source_index1 =  current_vector(2) + 1;
    source_index2 =  current_vector(3) + 1;
    
    message1 = messages{1}(source_index1);
    message2 = messages{2}(source_index2);
    
    product_term = message1 * message2;
    
    
    output_val = current_vector(out_position);
    in1_val = current_vector(in1_position);
    in2_val = current_vector(in2_position);
    
    if bitxor(in1_val, in2_val) == output_val
        factor = 1;
    else
        factor = 0;
    end
    
    message(target_index) = message(target_index) + factor * product_term;
    
    % message normalization
    message = message / sum(message);
    
end





end