% Configuration file with global variables used by the rest of the
% scripts. The user specified experiment is stored in variable "spec"
% -> adjust the experimental parameters as you need in this function

% input: user-defined experimental parameters
% output: experimental parameters stored in spec

function specify_config()

%----------------------------------------------------

global spec


% number of experiments: how many times do I want to execute Belief
% Propagation, while resimulating the dataset for every experiment
spec.NoSimulatedExperiments = 1;

% number of traces used per SASCA attack phase
spec.NoAttackTraces = 30;

% number of attack trace trials, i.e. in how many parts will we split the
% spec.NoAttackTraces
spec.NoAttackTraceTrials = 10;

% number of iterations of Belief Propagation algorithm, i.e. how many times
% I perform message passing using BP
spec.NoBPIterations = 5;

% simulated noise level - standard deviation
spec.NoiseSigma = 10.4;

% the cipher that SASCA is attacking
% -> the cipher is specified in \cipher\specify_attack_values_ciphername.m
% and in \cipher\specify_factor_graph_ciphername.m
spec.Cipher = 'one_time_pad';

% the profiling model used for leakage simulation
% -> the model is specified in \profile\compute_prob_modelname.m and
% \profile\generate_attacktraces_modelname.m and in
% \profile\specify_profile_modelname.m
spec.ProfileType = 'id_univariate_gauss';


%--------------------------------------------------------------------------
% The following variables are either derived from previous variables or 
% initialized here. No need to modify anything.

% attack vector trials
spec.AttackTracesVector = floor(linspace(1, spec.NoAttackTraces, ... 
                                        spec.NoAttackTraceTrials));
                                    

end