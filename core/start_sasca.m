% startup function that specifies the SASCA

function start_sasca()

% initialize global variables
% -> you need to choose experimental constants here
specify_config();
% result is stored in global variable spec

% specify your factor graph here
% -> you need to describe the factor graph
specify_factor_graph();
% result is stored in global variable spec

% generate factor graph based on your specification
% -> no need to modify this
generate_factor_graph();
% result is stored in global variable fg

% specify the profile construction
% -> you can provide specific profiles for the intermediate values 
specify_profile();
% result is stored in fg.Profiles

end