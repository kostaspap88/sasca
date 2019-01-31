%main file of Belief Propagation algorithm
%author: Kostas - kostaspap88@gmail.com - kpcrypto.net

%CAROLINE DELETED...GOODBYE CAROLINE
clear all;
%close all;

%initialize global variables
%->you need to choose constants here
specify_config();

%specify the global variables used by main.m
global fg no_sim_experiments no_attack_traces secret_value fg_spec attack_values;

%specify the necessary crypto operators for the cipher
%->you need to specify any custom cryptographic operators your cipher needs
specify_crypto_operations();
%the specifed operators are stored in operator_table

%specify your factor graph here
%->you need to describe the factor graph
specify_factor_graph();
%the graph specifications are stored in fg_spec

%generate factor graph based on your specification
%->no need to modify this
generate_factor_graph();
%the graph is stored in fg

%specify the template construction
%->you can provide specific templates for intermediate values 
specify_templates();
%the fg.Node fields .TemplateMean and .TemplateStd are updated

%run SASCA for several simulated experiments
for i=1:no_sim_experiments
    
    %simulate attack values of the current experiment
    %->you need to specify the computation of intermediate values
    specify_attack_values();
    %the generate plaintxt/key/intermediates are stored in attack values
       
    %update the factor graph with the attack values and generate attack
    %traces from the attack values
    %->no need to modify this
    generate_attack_traces();
    %the fg.Node fields .AttackValues and .AttackTraces are updated
    
    %belief propagation algorithm on the factor graph
    key_prob{j}=belief_propagation();
    
end




%repeat SASCA for "no_attack_traces" 
 max_attack_traces=no_attack_traces; %--UGLY CODE
% index=1;
% for no_attack_traces=1:max_attack_traces
%     
%     fail=0;
%     fail_ta=0;
%     %SASCA for no_sim_experiments
%     key_prob=cell(1,no_sim_experiments);
%     for j=1:no_sim_experiments
% 
%         %specify your cipher structure and simulate values
%         specify_crypto();
%         %simulate templates and attack traces using specified crypto
%         template_simulation();
%         
%         %belief propagation algorithm on the factor graph
%         key_prob{j}=belief_propagation();
%         
%         key_prob_ta{j}=template_attack();
%         
%         %success rate computation
%         [max_prob key_guess]=max(key_prob{j});
%         [max_prob_ta key_guess_ta]=max(key_prob_ta{j});
%         if ((key_guess-1)~=secret_value)
%             fail=fail+1;
%         end
%         if ((key_guess_ta-1)~=secret_value)
%             fail_ta=fail_ta+1;
%         end
%         
%     end
%     sr(1,index)=(1-fail/no_sim_experiments)*100
%     sr(2,index)=(1-fail_ta/no_sim_experiments)*100
%     index=index+1;
    
    
    
%end
