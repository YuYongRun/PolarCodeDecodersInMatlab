function psi_vec = get_psi_for_advanced_sc_decoder(node_type_matrix)
psi_vec = zeros(size(node_type_matrix, 1), 1);
for i = 1 : length(psi_vec)
    psi = node_type_matrix(i, 1);
    M = node_type_matrix(i, 2);
    reduced_layer = log2(M);
    for j = 1 : reduced_layer
        psi = floor(psi/2);
    end
    psi_vec(i) = psi;
end
end