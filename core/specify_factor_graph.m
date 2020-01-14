% specifying factor graph interface 

function specify_factor_graph()


global spec

if strcmp(spec.Cipher, 'one_time_pad')
    specify_factor_graph_onetimepad();
end

% -> interface extension
% if strcmp(spec.Cipher, 'your_cipher_here')
%     specify_factor_graph_yourcipherhere();
% end


end
