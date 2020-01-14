% This function computes the probabilities of leakage traces wrt a 
% univariate Gauss template

% This function matches with function specify_profile_idunivgauss.m

function probability = compute_prob_idunivgauss(current_factor_index, ...
                                        current_attack_trace, current_no_attack_traces)

global fg spec

mu = fg.Nodes.Profiles{current_factor_index}{1};
sigma = fg.Nodes.Profiles{current_factor_index}{2};  
current_factor_name = fg.Nodes.Name{current_factor_index};
hood_indexes = neighbors(fg, current_factor_index);

% if the leakage node has constant attack value for all attack 
% traces then we can combine the probabilities in a single message
% using their product
for k=hood_indexes'
    connected_var_name = fg.Nodes.Name{k};
    if (strcmp(fg.Nodes.ConstantOrRandom{current_factor_index}, ...
            'constant') == 1)     

        % probability computation for all attack traces
        prob = normpdf(fg.Nodes.AttackTraces{current_factor_index}(1:current_no_attack_traces, :), mu, sigma);

        probability = ones(1, 2^spec.SizeDict(connected_var_name)); 
        for i =1:current_no_attack_traces
            probability = probability .* prob(i, :);
            %message normalization
            probability = probability/sum(probability);    
        end


    end

    % if the leakage node has random value for all attack traces then
    % we cannot combine the probabilities. Instead we rely on a single
    % trace to create the message
    if (strcmp(fg.Nodes.ConstantOrRandom{current_factor_index}, ...
            'random') == 1)     
        % use the trace index to access the currently available trace      
        probability = normpdf(fg.Nodes.AttackTraces{current_factor_index}(current_attack_trace, :) , mu, sigma);

        % message normalization
        probability = probability/sum(probability);           
    end

end



end