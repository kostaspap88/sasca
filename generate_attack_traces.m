%this function updates the factor graph with the attack values and the attack traces
%->no need to modify this

function generate_attack_traces()


global fg attack_values no_attack_traces

%initialize attack traces
attack_traces=zeros(1,no_attack_traces);

%for all leakage and knowledge nodes
node_names=keys(attack_values)

for i=1:attack_values.Count
    
    %find the correct fg node
    name=node_names{i};
    index=find(strcmp(fg.Nodes.Name,name));
    values=attack_values(name);
    
    %update the factor graph attack values
    fg.Nodes.AttackValues{index}=values;
    
    
    %if it is leakage node generate (i.e. simulate) attack traces from these attack values
    if (strcmp(fg.Nodes.FactorType{index},'leak'))
        
        %simulate attack traces
        mu=fg.Nodes.TemplateMean{index}(values+1);
        sigma=fg.Nodes.TemplateStd{index}(values+1);
    
        for j=1:no_attack_traces
            attack_traces(j)=normrnd(mu(values(j)+1),sigma(values(j)+1));
        end
        fg.Nodes.AttackTraces{index}=attack_traces;
    end
end




end