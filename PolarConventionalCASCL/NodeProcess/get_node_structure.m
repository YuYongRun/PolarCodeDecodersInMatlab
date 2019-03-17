function node_type_structure = get_node_structure(frozen_bits)
global code_structure cnt_structure
code_structure = zeros(length(frozen_bits), 3);
cnt_structure = 1;
% node_identifier(frozen_bits, 1 : length(frozen_bits));
% node_identifier_no_45(frozen_bits, 1 : length(frozen_bits));
% node_identifier_no_12345(frozen_bits, 1 : length(frozen_bits));
node_identifier_large_node(frozen_bits, 1 : length(frozen_bits));
code_structure = code_structure(code_structure ~= 0);
code_structure = reshape(code_structure, length(code_structure)/3, 3);
node_type_structure = code_structure;
clear global;
end
%数字与节点型号的对应：
% -1 RATE0
% 1 RATE 1
% 2 REP
% 3 SPC
% 4 I
% 5 II
% 6 III
% 7 IV
% 8 V