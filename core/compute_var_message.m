% message computation

function message = compute_var_message(var_name, message_creation_factors_indexes)

global fg spec

% collect the var node index
var_index = fg.findnode(var_name);
% set temporary message to equiprobable
message = ones(1, 2^spec.SizeDict(var_name));

for k = message_creation_factors_indexes'
    message_edge = fg.findedge(k, var_index);
    partial_message = fg.Edges.R{message_edge};
    message = message .* partial_message;
    %normalization
    message=message/sum(message);
end



end