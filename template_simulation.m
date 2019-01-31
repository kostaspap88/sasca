%this function simulates the template mean and standard deviation of
%intermediate values used in SASCA. It also simulates attack traces.

function template_simulation()

global value_number noise_sigma fg no_attack_traces;


%initialize
attack_traces=zeros(1,no_attack_traces);
%simulate the attack traces using the attack values
for i=1:length(leak_index)
    attack_values=fg.Nodes.AttackValues{leak_index(i)};
    mu=fg.Nodes.TemplateMean{leak_index(i)}(attack_values+1);
    sigma=fg.Nodes.TemplateStd{leak_index(i)}(attack_values+1);
    for j=1:no_attack_traces
        attack_traces(j)=normrnd(mu(j),sigma(j));
    end
    fg.Nodes.AttackTraces{leak_index(i)}=attack_traces;
end

   



end