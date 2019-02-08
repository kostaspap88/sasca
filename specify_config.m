%Configuration file with all global variables used by the rest of the
%scripts. 
%->write any new global variables you need in this function

function specify_config()

%----------------------------------------------------


%number of experiments: how many times do I want to execute Belief
%Propagation, while simulating the dataset again for every experiment
global no_sim_experiments;
no_sim_experiments=1;

%size of intermediate values that we attack/template in bits
global value_bitsize;
%value_size: number of bits
value_bitsize=1;

%number of traces used per SASCA attack phase
global no_attack_traces;
no_attack_traces=5;

%number of iterations of Belief Propagation algorithm, i.e. how many times
%I perform message passing using BP
global no_bp_iterations;
no_bp_iterations=5;

%simulated noise level - standard deviation
global noise_sigma;
noise_sigma=0.3;

%factor graph specification by user. Contains all information about the
%structure of the factor graph
global fg_spec;
fg_spec=[];

%factor graph created by user. This is the core object used by the BP
%algorith to do message passing and marginalization
global fg;
fg=[];

%operator table with information about optype (xor21, and21, etc.). The
%operator table contains all defined operations i.e. all operations that
%the cipher can do. They are defined as <operator_name><no_ins><no_outs>s
global operator_table;
operator_table=[];

%number of operators used in cipher structure, i.e  the number of ANDs,
%XORs, Sboxes, etc. used by the cipher structure
global no_operators;
no_operators=0;

%name of secret variable in factor graph. This string has the key name.
global secret_name;
secret_name='';

%value of secret variable. This contains the true value of the key in order
%to compute the success rate of our attack
global secret_value

%univariate templates of all intermediate values
global templates
templates=[];

%attack values for all intermediate values
global attack_values
attack_values=[];

%------------------------------------------------------------------------------
%The following variables are derived from previous variables, no need to modify


%maximum value of intermediate values that we attack/template. E.g. 3-bit
%values can be at most 7.
global value_max;
value_max=2^value_bitsize-1;

%range of intermediate values that we attack/template. E.g. 3-bit values
%range from 0 until 7
global value_range;
%value_range: 0...max_value
value_range=0:value_max;

%number of distinct possible values of an intermediate value that we
%attack/template. E.g. when templating 3-bit values then 8 possible
%templates exist.
global value_number;
value_number=value_max+1;



end