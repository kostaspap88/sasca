function sr=success_rate(key_prob, secret_value, no_exp, no_attack_traces)

    key_guess=find(max(key_prob))-1;
    
    if (key_guess~=secret_value)
        fail{
    end

end