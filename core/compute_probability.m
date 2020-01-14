% probability function interface

function probability = compute_probability(current_factor_index, trace_index, current_no_attack_traces)

global spec

if strcmp(spec.ProfileType, 'id_univariate_gauss')
    probability = compute_prob_idunivgauss(current_factor_index, trace_index, current_no_attack_traces);
end

% -> interface expansion
% if strcmp(spec.ProfileType, 'your_profile_here')
%     probability = compute_prob_<yourprofilehere>(current_factor_index, trace_index);
% end


end