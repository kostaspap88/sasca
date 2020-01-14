% main file of the Soft Analytical Side Channel Attack
% author: Kostas Papagiannopoulos - kostaspap88@gmail.com - kpcrypto.net

% CAROLINE DELETED...GOODBYE CAROLINE
clear all;
close all;


% the global variable spec is the SASCA experiment specifications provided 
% by the user
global spec

% the global variable fg contains the factor graph, with the
% variable/factor nodes (fg.Nodes) and the messages passed on their edges
% (fg.Edges)
global fg

% matlab execution path
spec.path = 'C:\Users\nxf51168\Desktop\projects\sasca_new';
% add also the necessary subfolders to the path
addpath(genpath(spec.path));
addpath(genpath(strcat(spec.path, '\core')));
addpath(genpath(strcat(spec.path, '\profiles')));
addpath(genpath(strcat(spec.path, '\cipher')));

% start the SASCA experiment and factor graph
start_sasca();


%run SASCA for several simulated experiments
result_table_prob = cell(spec.NoAttackTraceTrials, spec.NoSimulatedExperiments);
result_table_found = zeros(spec.NoAttackTraceTrials, spec.NoSimulatedExperiments);
result_table_rank = zeros(spec.NoAttackTraceTrials, spec.NoSimulatedExperiments);
for experiment_index = 1:spec.NoSimulatedExperiments
    
    % simulate the attack values for the variables of current experiment
    specify_attack_values();
       
    % update the factor graph with the attack values and generate attack
    % traces from the attack values
    generate_attack_traces();
    % the fg.Node fields .AttackValues and .AttackTraces are updated
    
    % run SASCA on the same dataset and output the attack results different number of attack traces
    attack_trace_index = 1;
    for current_no_attack_traces = spec.AttackTracesVector
        
        sprintf('Computing BP experiment %d with %d attack traces', experiment_index, current_no_attack_traces)
        % run belief propagation algorithm on the factor graph
        [probability_of_secret, secret_found, secret_rank] = belief_propagation(current_no_attack_traces);
        
        % store the results for all experiments and all indexes of attack
        % traces
        result_table_prob{attack_trace_index, experiment_index} = probability_of_secret;
        result_table_found(attack_trace_index, experiment_index) = secret_found;
        result_table_rank(attack_trace_index, experiment_index) = secret_rank;
        
        attack_trace_index = attack_trace_index + 1;
    end
    
end

% compute the average success rate of SASCA across experiments
average_success_rate = mean(result_table_found, 2);
std_success_rate = std(result_table_found, 0, 2);

% compute the average rank of SASCA across experiments (max rank is 1)
average_rank = mean(result_table_rank, 2);
std_rank = std(result_table_rank, 0, 2);

% plot the results
plot_results(average_rank, average_success_rate, std_rank, std_success_rate);

% the program has ended
hello = 'banana_co'
we = 'really_love_you'
and = 'we_need_you'


