% generate attacktraces interface

function generate_attack_traces()

global spec;

if strcmp(spec.ProfileType, 'id_univariate_gauss')
    generate_attack_traces_idunivgauss(); 
end

% -> interface extension
% if strcmp(spec.ProfileType, 'your_profile_here')
%     generate_attack_traces_yourprofilehere(); 
% end


end