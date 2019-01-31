%This function specifies probability lookup tables for all operations
%supported by the cipher e.g. and, or, xor etc.
%->you can specify any cryptographic operators you need here

function specify_crypto_operations()

%How to add a new operator:
%Let Z = X o Y, "o" being the operator and let X,Y independent
%Create probability matrices using the following syntax 

%Mandatory:
%syntax: pc_operator-noinputs-nooutputs (conditional probability)
%define: pc_xor21(i,j,k) is the probability that the output of the
%"o" operator is i-1, given that the inputs are j-1 and k-1 respectively.
%notation: Pr[Z=i-1 | X=j-1 , Y=k-1]

%Optional:
%syntax: lut_operator-noinputs-nooutputs
%define:  lut_xor21(in1,in2) is equal to the result of the operation between
%in1-1 and in2-1.
%notation: in1-1 o in2-1

%Optional:
%syntax: pm_operator-noinputs-nooutputs (marginal probability)
%define: pm_xor21(i) is the probability that the output of the
%"o" operator is i-1.
%notation: Pr[Z=i-1]

%Optional:
%syntax: pj_operator-noinputs-nooutputs (joint probability)
%define: pj_xor21(i,j,k) is the probability that the output of the
%"o" is i-1 and in1 is j-1 and in2 is k-1.
%notation: Pr[Z=i-1 , X=j-1 , Y=k-1]

%specify the global values needed by crypto_operations.m
global value_number  value_range value_bitsize operator_table no_operators;

%initialize the operator table
operator_table = containers.Map();


%xor21 operator start------------------------------------------------------
    

%Compute the operation xor with 2 inputs and 1 output
lut_xor21 = zeros(value_number,value_number); %optional
pm_xor21 = zeros(value_number,1); %optional
pc_xor21 = zeros(value_number,value_number,value_number); %required
pj_xor21 = zeros(value_number,value_number,value_number); %optional
pchw_xor21 = zeros(value_number,value_number,value_number); %optional

count_xor21=zeros(value_number,1);
for out1=value_range
    for in1=value_range
    for in2=value_range
        
        result_xor=bitxor(in1,in2);
        if(out1==result_xor)
            pc_xor21(out1+1,in1+1,in2+1)=1;
            count_xor21(out1+1)=count_xor21(out1+1)+1;
        end
        
        lut_xor21(in1+1,in2+1) = result_xor; 
        
    end
    end
end

pm_xor21=2^(-value_bitsize)*2^(-value_bitsize)*count_xor21;
pj_xor21=2^(-value_bitsize)*2^(-value_bitsize)*pc_xor21;


%create the operator table for xor21

%use the operator name using as <operator><no_in><no_out>
%set the number of operands (in this case 2+1 = 3)
xor21_operator.NoOperands=3;

%set the probability matrix (conditinal probability). Note that the
%conditional probability changes based on the direction.
%syntax: Prob( input_or_output direction, in_or_out var index ) 
%direction=1 if input and direction=2 if output

%the next entry specifies the cond.prob. matrix when we send messages
%towards the input, in particular on the 1st input.
xor21_operator.Prob{1,1}=pc_xor21;
%the next entry specifies the cond.prob. matrix when we send messages
%towards the input, in particular on the 2nd input.
xor21_operator.Prob{1,2}=pc_xor21;
%the next entry specifies the cond.prob. matrix when we send messages
%towards the output, in particular on the 1st output.
xor21_operator.Prob{2,1}=pc_xor21;
%notice that the structure of xor21 implies that the conditional prob.
%matrix is the same, regardless of direction. This does not hold in
%general.

%store on map 
operator_table('xor21')=xor21_operator;

%xor21 operator end--------------------------------------------------------







% %and21 operator start------------------------------------------------------
% 
% %Compute the operation and with 2 inputs and 1 output
% lut_and21 = zeros(value_number,value_number); %optional
% pm_and21 = zeros(value_number,1); %optional
% pc_and21 = zeros(value_number,value_number,value_number);%required
% pc_and21_2 = zeros(value_number,value_number,value_number);%optional
% pc_and21_3 = zeros(value_number,value_number,value_number);%optional
% pj_and21 = zeros(value_number,value_number,value_number);%optional
% 
% 
% and21_table=combvec(combvec(1:value_number,1:value_number),1:value_number);
% 
% count_and21=zeros(value_number,1);
% for out1=value_range
%     for in1=value_range
%     for in2=value_range
%         
%         result_and=bitand(in1,in2);
%         
%         result_and_2=bitand(out1,in1);
%         
%         result_and_3=bitand(out1,in2);
%         
%         if(out1==result_and)
%             pc_and21(out1+1,in1+1,in2+1)=1;
%             count_and21(out1+1)=count_and21(out1+1)+1;
%         end
%         
%         if(in1==result_and_2)
%             pc_and21_2(in1+1,out1+1,in2+1)=1;
%         end
%         
%         if(in2==result_and_3)
%             pc_and21_3(in2+1,in1+1,out1+1)=1;
%         end
%         
%         lut_and21(in1+1,in2+1) = result_and; 
%         
%     end
%     end
% end
% 
% pm_and21=2^(-value_bitsize)*2^(-value_bitsize)*count_and21;
% pj_and21=2^(-value_bitsize)*2^(-value_bitsize)*pc_and21;
% 
% 
% %set the operator table entries for and21
% 
% and21_operator.NoOperands=3;
% %syntax: Prob( input_or_output direction, in_or_out var index ) 
% %direction=1 if input and direction=2 if output
% and21_operator.Prob{1,1}=pc_and21_2; 
% and21_operator.Prob{1,2}=pc_and21_3;
% and21_operator.Prob{2,1}=pc_and21;
% 
% operator_table('and21')=and21_operator;
% 
% %and21 operator end--------------------------------------------------------






%your operator start-------------------------------------------------------

%->specify your new operator here

%your operator end---------------------------------------------------------






%finally update the no_operators 
no_operators = operator_table.Count;


end
