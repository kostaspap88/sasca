% Attack values specification interface

function specify_attack_values()


global spec

if strcmp(spec.Cipher, 'one_time_pad')
    specify_attack_values_onetimepad()
end

% -> extending the interface
% if strcmp(spec.Cipher, 'your_cipher_here')
%     specify_attack_values_yourcipherhere()
% end


end