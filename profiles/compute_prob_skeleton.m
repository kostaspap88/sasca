% This function computes the probabilities of leakage traces wrt an
% a leakage model

% -> you can make your own function compute_prob_<technique> where you
% compute the probability using another method
% -> this function has to match with specify_profile_<technique> and
% generate_attack_traces_<technique>

function prob = compute_prob_skeleton(current_factor_index, ...
                                        current_attack_trace_index)

global fg


% if the leakage node has constant attack value for all attack 
% traces then we can combine the probabilities in a single message
% using their product
if (strcmp(fg.Nodes.ConstantOrRandom{current_factor_index}, ...
        'constant') == 1)     
    
    % compute probability of all leakage traces here
    % prob = 
    prob = prod(prob);

    %message normalization
    prob = prob/sum(prob);         
            
end

% if the leakage node has random value for all attack traces then
% we cannot combine the probabilities. Instead we rely on a single
% trace to create the message
if (strcmp(fg.Nodes.ConstantOrRandom{current_factor_index}, ...
        'random') == 1) 
    
    % use the trace index to access the currently available trace    
    current_trace = fg.Nodes.AttackTraces{current_factor_index}(current_attack_trace_index);
    
    % COMPUTE PROBABILITY OF CURRENT LEAKAGE TRACE HERE
    % prob = 

    % message normalization
    prob = prob/sum(prob);           
end




end