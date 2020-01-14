% profiling function interface

function specify_profile()

global spec

if spec.ProfileType == 'id_univariate_gauss'
    specify_profile_idunivgauss();
end

% -> you can expand the profile options

% if spec.ProfileType == 'your_profile_here'
%     specify_profile_<yourprofilehere>();
% end



end