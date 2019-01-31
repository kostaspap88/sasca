function [key_prob]=belief_propagation()

global no_bp_iterations fg value_number no_attack_traces operator_table secret_name;


%message initialization step

%Initial messages from leakage/knowledge nodes to variable nodes

%get all leakage factor nodes
leak_index=find(strcmp(fg.Nodes.FactorType,'leak'));

%for every leakage factor node send a message to the neighbouring variable
%nodes
for i=1:length(leak_index)
    %select a leakage factor node
    current_factor_node=leak_index(i);
    %find all its neighbouring variable nodes
    hood_index=neighbors(fg,current_factor_node);
    for j=1:length(hood_index)
        current_var_node=hood_index(j);
        message=ones(1,value_number);
        for k=1:no_attack_traces
            attack_trace=fg.Nodes.AttackTraces{current_factor_node}(k);
            mu=fg.Nodes.TemplateMean{current_factor_node};
            sigma=fg.Nodes.TemplateStd{current_factor_node};
            message=message.*normpdf(attack_trace,mu,sigma);
        end
        %normalization
        message=message/sum(message);
        %store message
        %syntax: .Message{sentToThisNode, sentFromThisNode}
        fg.Nodes.Message{current_var_node,current_factor_node}=message;
    end
end

%get all knowledge factor nodes
know_index=find(strcmp(fg.Nodes.FactorType,'know'));

%for every knowledge factor node send a message to all its neighbouring
%variable nodes
for i=1:length(know_index)
    %select a knowledge factor node
    current_factor_node=know_index(i);
    %find all its neighbouring variable nodes
    hood_index=neighbors(fg,current_factor_node);
    for j=1:length(hood_index)
        current_var_node=hood_index(j);
        %generate the initial knowledge message
        message=zeros(1,value_number);
        %the value of known factor vars is fixed during attack, thus (1)
        %PERHAPS RETHINK (1) indexing
        attack_value=fg.Nodes.AttackValues{current_factor_node}(1);
        message(attack_value+1)=1;
        %syntax: .Message{sentToThisNode, sentFromThisNode}
        fg.Nodes.Message{current_var_node,current_factor_node}=message;
        
    end
end

%get all variable nodes
var_index=find(strcmp(fg.Nodes.Type,'var'));

for iteration=1:no_bp_iterations

    %for every variable node in the graph send messages to all its 
    %neighbouring factor nodes  
    for i=1:length(var_index)
        %select a var node
        current_var_node=var_index(i);
        %find all its neighbouring factor nodes
        hood_index=neighbors(fg,current_var_node);
        for j=1:length(hood_index)
            %select the factor node
            current_factor_node=hood_index(j);
            %create message for current_factor_node. To do this use messages
            %stored in all neighboring factor nodes of current_var_node,
            %except for the factor node current_factor_node
            message_creation_factors=setdiff(hood_index,current_factor_node);
            message=ones(1,value_number);
            for k=1:length(message_creation_factors)
                %CHECK THIS AGAIN
                message = message .* fg.Nodes.Message{current_var_node,message_creation_factors(k)};
            end
            message=message/sum(message);
            %syntax: .Message{sentToThisNode, sentFromThisNode}
            fg.Nodes.Message{current_factor_node,current_var_node}=message;
        end
    end
    
    %get all factor nodes
    factor_index=find(strcmp(fg.Nodes.Type,'factor'));
    
    %for every factor node in the graph send messages to all its 
    %neighbouring variable nodes  
    for i=1:length(factor_index)
        %select a factor node
        current_factor_node=factor_index(i);
        %get its type and optype 
        factortype=cell2mat(fg.Nodes.FactorType(current_factor_node));
        
        
        %find all its neighbouring variable nodes
        hood_index=neighbors(fg,current_factor_node);
        for j=1:length(hood_index)
            %select the variable node
            current_var_node=hood_index(j);       
            
            %apply behavior of factor node
            switch factortype
                case 'know' 
                    %knowledge nodes are leaf nodes
                    message=fg.Nodes.Message{current_factor_node,current_var_node};
                    
                case 'leak'
                    %leakage nodes are leaf nodes
                    message=fg.Nodes.Message{current_factor_node,current_var_node};
                    
                case 'op'
                    %operator factor nodes are not leaf nodes and have at
                    %least 2 edges connected to them
                    
                    %to create message to current_var_node, use the whole
                    %neibourhood of current_factor_node, excluding the
                    %current_var_node
                    message_creation_vars=setdiff(hood_index,current_var_node);            
                    
                    %find the operator name e.g. XOR1,AND1,XOR2,AND2, etc
                    current_factor_name=fg.Nodes.Name{current_factor_node};
                    %find the IO of the specific operator
                    current_factor_input=fg.Nodes.Input{current_factor_node};
                    current_factor_output=fg.Nodes.Output{current_factor_node};
                    %find the operator type e.g. xor21, and21 etc. and its
                    %respetive index in the operator table
                    current_factor_type=cell2mat(fg.Nodes.OpType(current_factor_node));
                    op_index=find(strcmp(operator.Type,current_factor_type));
                    %current_factor_node sends message to current_var_node.
                    %find the name of the current_var_node
                    current_var_name=fg.Nodes.Name{current_var_node};
                    
                    %use the current_var_name to find if it's an input or
                    %output (direction 1 or 2) and which input or output is it (in_index,out_index)
                    in_index=find(cell2mat(current_factor_input)==current_var_name);
                    out_index=find(cell2mat(current_factor_output)==current_var_name);
                    index=union(in_index,out_index);
                    
                    if (isempty(in_index))
                        direction=2; %the message goes towards the output    
                    end
                    if (isempty(out_index))
                        direction=1; %the message goes towards the input                        
                    end
                    
                    %find the probability matrix of 'op_index' (1/2/... corresponding to xor21/and21/...)
                    %that is sending message towards 'direction' (in/out) and in this direction the
                    %variable index is 'index' (in1/in2/... or out1/out2/...)
                    op_prob=operator.Prob{op_index}{direction,index};
                    %op_prob=op_prob{op_index,direction,index};

                    %CONTINUE HERE
                    %op_table=operator.Table{op_index};
                    
                    no_operands=operator.NoOperands{op_index};
                    
                    %get the product messages
                    for k=1:length(message_creation_vars)
                        prod_message{k}=fg.Nodes.Message{current_factor_node,message_creation_vars(k)};
                    end
                    
                    %GENERALIZE THIS MORE
                    switch no_operands
                        
                        case 3
                            
                        sum_message=zeros(1,value_number);
                        for x1=1:value_number
                            for x2=1:value_number
                                for x3=1:value_number
                                    prob=op_prob(x1,x2,x3);
                                    
                                    sum_message(x1)=sum_message(x1)+prob*prod_message{1}(x2)*prod_message{2}(x3);
                                end
                            end
                        end
                        
                        case 2
                            
                        sum_message=zeros(1,value_number);
                        for x1=1:value_number
                            for x2=1:value_number
                                prob=op_prob(x1,x2);
                                    
                                sum_message(x1)=sum_message(x1)+prob*prod_message{1}(x2);
                            end
                        end
                        
                            
                    end
                    %END OF GENERALIZABLE PART
                    
                    message=sum_message/sum(sum_message); 
            end
            
            fg.Nodes.Message{current_var_node,current_factor_node}=message;
           
        end
    end

end

%Marginalize: for every variable node use all its neigbouring factor nodes
for i=1:length(var_index)
    %select current var node
    current_var_node=var_index(i);
    %find all its neighbouring factor nodes
    hood_index=neighbors(fg,current_var_node);
    for j=1:length(hood_index)
        current_factor_node=hood_index(j);
        message=fg.Nodes.Message{current_var_node,current_factor_node};
        fg.Nodes.Marginal{var_index(i)}=fg.Nodes.Marginal{var_index(i)}.*message;
    end
    %CHECK AGAIN
    fg.Nodes.Marginal{var_index(i)}=fg.Nodes.Marginal{var_index(i)}/sum(fg.Nodes.Marginal{var_index(i)});
end

%print key probability distribution
%find the node index of the secret
secret_index=find(strcmp(fg.Nodes.Name,secret));
key_prob=fg.Nodes.Marginal{secret_index};




end