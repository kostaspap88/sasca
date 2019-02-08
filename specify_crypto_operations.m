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
pc_xor21_out1 = zeros(value_number,value_number,value_number); %required
pc_xor21_in1 = zeros(value_number,value_number,value_number); %required
pc_xor21_in2 = zeros(value_number,value_number,value_number); %required


it_vector=combvec(value_range+1,value_range+1,value_range+1);

for i=1:size(it_vector,2)
    vec=it_vector(:,i);
    
    result_xor=bitxor(vec(2)-1,vec(3)-1);
    if ((vec(1)-1)==result_xor)
        %Pr z|xy
        pc_xor21_out1(vec(1),vec(2),vec(3))=1;
    end
    %Pr x|yz, Pr y|xz
    pc_xor21_in1(vec(1),vec(2),vec(3)) = pc_xor21_out1(vec(3),vec(1),vec(2));
    pc_xor21_in2(vec(2),vec(1),vec(3)) = pc_xor21_out1(vec(3),vec(1),vec(2));
    
end


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
xor21_operator.Prob{1,1}=pc_xor21_in1;
%the next entry specifies the cond.prob. matrix when we send messages
%towards the input, in particular on the 2nd input.
xor21_operator.Prob{1,2}=pc_xor21_in2;
%the next entry specifies the cond.prob. matrix when we send messages
%towards the output, in particular on the 1st output.
xor21_operator.Prob{2,1}=pc_xor21_out1;
%notice that the structure of xor21 implies that the conditional prob.
%matrix is the same, regardless of direction. This does not hold in
%general.

xor21_operator.Probability=pc_xor21_out1;
xor21_operator.Table=it_vector;
%store on map 
operator_table('xor21')=xor21_operator;

%xor21 operator end--------------------------------------------------------







%and21 operator start------------------------------------------------------


%Compute the operation xor with 2 inputs and 1 output
lut_and21 = zeros(value_number,value_number); %optional
pc_and21_out1 = zeros(value_number,value_number,value_number); %required
pc_and21_in1 = zeros(value_number,value_number,value_number); %required
pc_and21_in2 = zeros(value_number,value_number,value_number); %required


it_vector=combvec(value_range+1,value_range+1,value_range+1);

for i=1:size(it_vector,2)
    vec=it_vector(:,i);
    
    result_and=bitand(vec(2)-1,vec(3)-1);
    if ((vec(1)-1)==result_and)
        %Pr z|xy
        pc_and21_out1(vec(1),vec(2),vec(3))=1;
    end
    %Pr x|yz, Pr y|xz
    pc_and21_in1(vec(1),vec(2),vec(3)) = pc_and21_out1(vec(3),vec(1),vec(2));
    pc_and21_in2(vec(2),vec(1),vec(3)) = pc_and21_out1(vec(3),vec(1),vec(2));
    
end


%create the operator table for and21

%use the operator name using as <operator><no_in><no_out>
%set the number of operands (in this case 2+1 = 3)
and21_operator.NoOperands=3;

%set the probability matrix (conditinal probability). Note that the
%conditional probability changes based on the direction.
%syntax: Prob( input_or_output direction, in_or_out var index ) 
%direction=1 if input and direction=2 if output

%the next entry specifies the cond.prob. matrix when we send messages
%towards the input, in particular on the 1st input.
and21_operator.Prob{1,1}=pc_and21_out1;
%the next entry specifies the cond.prob. matrix when we send messages
%towards the input, in particular on the 2nd input.
and21_operator.Prob{1,2}=pc_and21_in1;
%the next entry specifies the cond.prob. matrix when we send messages
%towards the output, in particular on the 1st output.
and21_operator.Prob{2,1}=pc_and21_in2;
%notice that the structure of xor21 implies that the conditional prob.
%matrix is the same, regardless of direction. This does not hold in
%general.

and21_operator.Probability=pc_xor21_out1;
and21_operator.Table=it_vector;

%store on map 
operator_table('and21')=and21_operator;

%and21 operator end--------------------------------------------------------






%your operator start-------------------------------------------------------

%->specify your new operator here

%your operator end---------------------------------------------------------






%finally update the no_operators 
no_operators = operator_table.Count;


end
