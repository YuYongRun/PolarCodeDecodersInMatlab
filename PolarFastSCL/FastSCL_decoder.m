function polar_info_esti = FastSCL_decoder(llr, L, info_bits, lambda_offset, llr_layer_vec, bit_layer_vec, psi_vec, node_type_matrix, H_crc)
%2018.1.7.14:16 Yu Y. R.
%LLR-based SCL deocoder
%Systematic polar code used
%4 nodes are identified and decoded, i.e., rate0, rate1, rep, spc,
%No BLER loss, while using fast algorithms.
%const
N = length(llr);
m = log2(N);
%memory declared
P = zeros(N - 1, L); %llr is public-used, so N - 1 is enough.
C = zeros(2 * N - 1, 2 * L);
PM = zeros(L, 1);
activepath = zeros(L, 1);
lazy_copy = zeros(m, L); 
%initialize the 1st SC decoder
activepath(1) = 1;
lazy_copy(:, 1) = 1;
%decoding starts
%default: in the case of path clone in REP and leaf node,
%origianl always corresponds to bit 0s, while the new path bit 1s.
for i_node = 1 : size(node_type_matrix, 1)
    current_index = node_type_matrix(i_node, 1);
    llr_layer = llr_layer_vec(current_index);
    M = node_type_matrix(i_node, 2);%number of leaf nodes in this constituent node
    reduced_layer = log2(M); %For LLR recursion, this reduced layer denotes where to stop; For Bit recursion, this denotes where to start.
    psi = psi_vec(i_node);%This psi is used for bits recursion
    psi_mod_2 = mod(psi, 2);%To decide whether the bit recuision should continue. 1 : continue; 0 : stop.
    for l_index = 1 : L
        if activepath(l_index) == 0
            continue;
        end
        switch current_index
            case 1
                index_1 = lambda_offset(m);
                for beta = 0 : index_1 - 1
                    P(beta + index_1, l_index) = sign(llr(beta + 1)) *  sign(llr(beta + index_1 + 1)) * min(abs(llr(beta + 1)), abs(llr(beta + index_1 + 1)));
                end
                for i_layer = m - 2 : -1 : reduced_layer
                    index_1 = lambda_offset(i_layer + 1);
                    index_2 = lambda_offset(i_layer + 2);
                    for beta = index_1 : index_2 - 1
                        P(beta, l_index) = sign(P(beta + index_1, l_index)) *  sign(P(beta + index_2, l_index)) * ...
                            min(abs(P(beta + index_1, l_index)), abs(P(beta + index_2, l_index)));
                    end
                end
            case N/2 + 1
                index_1 = lambda_offset(m);
                for beta = 0 : index_1 - 1
                    x_tmp = C(beta + index_1, 2 * l_index - 1);
                    P(beta + index_1, l_index) = (1 - 2 * x_tmp) * llr(beta + 1) + llr(beta + index_1 + 1);
                end
                for i_layer = m - 2 : -1 : reduced_layer
                    index_1 = lambda_offset(i_layer + 1);
                    index_2 = lambda_offset(i_layer + 2);
                    for beta = index_1 : index_2 - 1
                        P(beta, l_index) = sign(P(beta + index_1, l_index)) *  sign(P(beta + index_2, l_index)) * ...
                            min(abs(P(beta + index_1, l_index)), abs(P(beta + index_2, l_index)));
                    end
                end
            otherwise
                index_1 = lambda_offset(llr_layer + 1);
                index_2 = lambda_offset(llr_layer + 2);
                for beta = index_1 : index_2 - 1
                    %lazy copy
                    P(beta, l_index) = (1 - 2 * C(beta, 2 * l_index - 1)) * P(beta + index_1, lazy_copy(llr_layer + 2, l_index)) + P(beta + index_2, lazy_copy(llr_layer + 2, l_index));
                end
                for i_layer = llr_layer - 1 : -1 : reduced_layer
                    index_1 = lambda_offset(i_layer + 1);
                    index_2 = lambda_offset(i_layer + 2);
                    for beta = index_1 : index_2 - 1
                        P(beta, l_index) = sign(P(beta + index_1, l_index)) *  sign(P(beta + index_2, l_index)) * ...
                            min(abs(P(beta + index_1, l_index)), abs(P(beta + index_2, l_index)));
                    end
                end
        end
    end%LLR calculations. You may fold thiis code block.
    index_vec = M : 2 * M - 1;
    switch node_type_matrix(i_node, 3)
        case -1%****RATE 0*****
            x = zeros(M, 1);
            for l_index = 1 : L
                if activepath(l_index) == 0
                    continue;
                end
                C(index_vec, psi_mod_2 + 2 * l_index - 1) = x;
                PM(l_index) = PM(l_index) + sum(log(1 + exp(-P(index_vec, l_index)))); 
                %Do not forget updating path metric in rate 0 nodes
                %No copy in Rate 0 node
            end
        case 1%*****RATE 1*****
            %input LLR: P(index_vec, :)
            [PM, activepath, selected_subcodeword, lazy_copy] = Rate1(M, P(index_vec, :), activepath, PM, L, lazy_copy);
            %output: estimated sub polar codeword: 'selected_subcodeword'.
            for l_index = 1 : L
                if activepath(l_index) == 0
                    continue
                end
                C(index_vec, 2 * l_index - 1 + psi_mod_2) = selected_subcodeword(:, l_index);
            end
        case 2%*****REP*****
           [PM, activepath, lazy_copy, selected_subcodeword] = Rep(PM, P(index_vec, :), activepath, L, M, lazy_copy);
           for l_index = 1 : L
               if activepath(l_index) == 0
                   continue
               end
               C(index_vec, 2 * l_index - 1 + psi_mod_2) = selected_subcodeword(:, l_index);
           end
        case 3%*******SPC*******
            [PM, activepath, selected_subcodeword, lazy_copy] = SPC(index_vec, P(index_vec, :), activepath, PM, L, lazy_copy);
            for l_index = 1 : L
                if activepath(l_index) == 0
                    continue
                end
                C(index_vec, 2 * l_index - 1 + psi_mod_2) = selected_subcodeword(:, l_index);
            end
    end
    %Internal Bits Update for each active path
    bit_layer = bit_layer_vec(current_index + M - 1);
    for l_index = 1 : L
        if activepath(l_index) == 0
            continue;
        end
        if psi_mod_2 == 1%right child of its mother
            for i_layer = reduced_layer : bit_layer - 1
                index_1 = lambda_offset(i_layer + 1);
                index_2 = lambda_offset(i_layer + 2);
                for beta = index_1 : index_2 - 1
                    C(beta + index_1, 2 * l_index) = mod(C(beta, 2 * lazy_copy(i_layer + 1, l_index) - 1) + C(beta, 2 * l_index), 2);
                    C(beta + index_2, 2 * l_index) = C(beta, 2 * l_index);
                end
            end
            index_1 = lambda_offset(bit_layer + 1);
            index_2 = lambda_offset(bit_layer + 2);
            for beta = index_1 : index_2 - 1
                C(beta + index_1, 2 * l_index - 1) = mod(C(beta, 2 * lazy_copy(bit_layer + 1, l_index) - 1) + C(beta, 2 * l_index), 2);
                C(beta + index_2, 2 * l_index - 1) = C(beta, 2 * l_index);
            end
        end
    end
    %lazy copy
    if i_node < size(node_type_matrix, 1)
        for i_layer = 1 : llr_layer_vec(current_index + M) + 1
            for l_index = 1 : L
                lazy_copy(i_layer, l_index) = l_index;
            end
        end
    end
end
%select the best path
[~, path_ordered] = sort(PM);
for l_index = 1 : L
    path_num = path_ordered(l_index);
    x = C(end - N + 1 : end, 2 * path_num - 1);
    info_with_crc = x(info_bits);
    err = sum(mod(H_crc * info_with_crc, 2));
    if err == 0
        polar_info_esti = info_with_crc;
        break;
    else
        if l_index == L
            x = C(end - N + 1 : end, 2 * path_ordered(1) - 1);
            polar_info_esti = x(info_bits);
        end
    end
end
end