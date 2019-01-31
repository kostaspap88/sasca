%Hamming weight computation function

function hw = hw(value)
     
     hw=sum(dec2bin(value) == '1');

end