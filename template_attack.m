function [prob]=template_attack()

global fg no_attack_traces value_number;

%find index of leakage of secret in graph
lkey_index=find(strcmp(fg.Nodes.Name,'Lk')); %--UGLY CODE

%get mean and std of key leakage
mu=cell2mat(fg.Nodes.TemplateMean(lkey_index));
sigma=cell2mat(fg.Nodes.TemplateStd(lkey_index));


max_attack_traces=no_attack_traces; %--UGLY CODE
index=1;

prob=ones(1,value_number);
for index=1:max_attack_traces   
    %get attack traces of leakage of secret in graph
    attack_traces=cell2mat(fg.Nodes.AttackTraces(lkey_index));

    %compute prob
    prob=prob.*normpdf(attack_traces(index),mu,sigma);
    
end
prob=prob/sum(prob);

end