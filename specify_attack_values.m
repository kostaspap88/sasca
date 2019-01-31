%this function  simulates attack values of the current experiment
%->you need to specify the computation of intermediate values

function specify_attack_values()


global fg secret_value attack_values no_attack_traces;

%initialize the attack values table
attack_values = containers.Map();

%specify the value of the unknown secret key
secret_value=0;

%simulate the attack values for every known or leaky value of the factor graph
x=2*ones(1,no_attack_traces); %fixed input e.g. x=2 (known during attack)
k=secret_value*ones(1,no_attack_traces); %fixed key k=0 (unknown during attack)
y=bitxor(x,k); % y = k xor x 

%assign the attack values to the knowledge/leakage factor nodes
attack_values('Kx')=x;
attack_values('Lk')=k;
attack_values('Ly')=y;


end