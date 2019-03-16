function polar_info_esti = FastSCdecoder(llr, info_bits, node_type_structure, lambda_offset, llr_layer_vec, psi_vec, bit_layer_vec)
N = length(llr);
n = log2(N);
C = zeros(2 * N - 1, 2);%Bit vector
P = zeros(2 * N - 1, 1);%LLR vector
P(end - N + 1 : end) = llr;%LLR initialization
for i_node = 1 : size(node_type_structure, 1)
    M = node_type_structure(i_node, 2);%size of subcode
    reduced_layer = log2(M); 
    %reduced_layer denotes where to stop  LLR calculation
    %reduced_layer also denotes where to start Internal Bits calculation.
    llr_layer = llr_layer_vec(node_type_structure(i_node, 1));
    %llr_layer denotes where to start LLR calculation
    bit_layer = bit_layer_vec(node_type_structure(i_node, 1) + M - 1);
    %bit_layer denotes where to stop Internal Bits calculation.
    psi = psi_vec(i_node);%This psi is used for bits recursion
    psi_mod_2 = mod(psi, 2);
    if i_node == 1%first LLR calculation only uses f function.
        for i_layer = n - 1 : -1 : reduced_layer
            index_1 = lambda_offset(i_layer + 1);
            index_2 = lambda_offset(i_layer + 2);
            for beta = index_1 : index_2 - 1
                P(beta) = sign(P(beta + index_1)) *  sign(P(beta + index_2)) * min(abs(P(beta + index_1)), abs(P(beta + index_2)));
            end
        end
    else
        index_1 = lambda_offset(llr_layer + 1);
        index_2 = lambda_offset(llr_layer + 2);
        for beta = index_1 : index_2 - 1
            P(beta) = (1 - 2 * C(beta, 1)) * P(beta + index_1) + P(beta + index_2);
        end
        for i_layer = llr_layer - 1 : -1 : reduced_layer
            index_1 = lambda_offset(i_layer + 1);
            index_2 = lambda_offset(i_layer + 2);
            for beta = index_1 : index_2 - 1
                P(beta) = sign(P(beta + index_1)) *  sign(P(beta + index_2)) * min(abs(P(beta + index_1)), abs(P(beta + index_2)));
            end
        end
    end
    switch node_type_structure(i_node, 3)
        case -1%RATE 0
            for j = M : 2 * M - 1
                C(j, psi_mod_2 + 1) = 0;
            end
        case 1%RATE 1
            for j = M : 2 * M - 1
                C(j, psi_mod_2 + 1) = P(j) < 0;
            end
        case 2%REP
            sum_llr = 0;
            for j = M : 2 * M - 1
                sum_llr = sum_llr + P(j);
            end
            rep_bit = sum_llr < 0;
            for j = M : 2 * M - 1
                C(j, psi_mod_2 + 1) = rep_bit;
            end
        case 3%spc
            llr_sub_polar_code = zeros(M, 1);
            for j =  M : 2 * M - 1
                llr_sub_polar_code(j - M + 1) = P(j);
            end
            x = llr_sub_polar_code < 0;
            if mod(sum(x), 2) ~= 0%if SPC constraint is ont satisfied
                alpha_plus = abs(llr_sub_polar_code);
                [~, min_index] = min(alpha_plus);
                x(min_index) = mod(x(min_index) + 1, 2);
            end
            for j = M : 2 * M - 1
                C(j, psi_mod_2 + 1) = x(j - M + 1);
            end
    end
    if  psi_mod_2 == 1%bit recursion
        for i_layer = reduced_layer : bit_layer - 1
            index_1 = lambda_offset(i_layer + 1);
            index_2 = lambda_offset(i_layer + 2);
            for beta = index_1 : index_2 - 1
                C(beta + index_1, 2) = mod(C(beta, 1) + C(beta, 2), 2);
                C(beta + index_2, 2) = C(beta, 2);
            end
        end
        index_1 = lambda_offset(bit_layer + 1);
        index_2 = lambda_offset(bit_layer + 2);
        for beta = index_1 : index_2 - 1
            C(beta + index_1, 1) = mod(C(beta, 1) + C(beta, 2), 2);
            C(beta + index_2, 1) = C(beta, 2);
        end 
    end
end
x = C(end - N + 1 : end, 1);
polar_info_esti = x(info_bits);
end