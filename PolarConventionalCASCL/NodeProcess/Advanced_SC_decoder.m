function x = Advanced_SC_decoder(llr, frozen_bits, node_type_matrix, lambda_offset_)
%Theoretically, this decoder has much lower latency compared with
%traditional SC decoder because 9 kinds of specific constituent nodes are
%identified and decoded with alternative methods instead of successive
%cancellation. However, due to complex logical that is employed to
%distingguish above nodes, the decoding speed is even slightly lower than traditional SC in terms of MATLAB implementation. 
N = length(llr);
m = log2(N);
C = zeros(2 * N - 1, 2);
P = zeros(2 * N - 1, 1);
P(end - N + 1 : end) = llr;
node_type_matrix_cnt = 1;
phi = 0;
while(phi < N)
    if (phi + 1) == node_type_matrix(node_type_matrix_cnt, 1)
        switch node_type_matrix(node_type_matrix_cnt, 3)
            case -1%RATE 0
                M = node_type_matrix(node_type_matrix_cnt, 2);
                reduced_layer = log2(M); %This reduced layer denotes where to stop.
                psi = phi;%This psi leads you to a known (higher level with already obtained LLRs) layer.
                psi_ = phi;%This psi_ is used for bits recursion
                for i = 1 : reduced_layer
                    psi_ = floor(psi_/2);
                end
                layer = 0;%This layer denotes where to start.
                
                if phi ~= 0
                    while(mod(psi, 2) == 0)
                        psi = floor(psi/2);
                        layer = layer + 1;
                    end
                end
                
                if phi == 0
                    for i_layer = m - 1 : -1 : reduced_layer%NOT FULL LAYER = 0
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        for beta = 0 : index_1 - 1
                            P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                                min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                        end
                    end
                else
                    for i_layer = layer: -1 : reduced_layer
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        if i_layer == layer
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                            end
                        else
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                                    min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                            end
                        end
                    end
                end
                
                if mod(psi_, 2) == 0
                    C(M : 2 * M - 1, 1) = zeros(M, 1);
                else
                    C(M : 2 * M - 1, 2) = zeros(M, 1);
                    while(mod(psi_, 2) == 1)
                        psi_ = floor(psi_/2);
                        index_1 = lambda_offset_(reduced_layer + 1);
                        index_2 = lambda_offset_(reduced_layer + 2);
                        for beta = 0 : index_1 - 1
                            C(2 * beta + index_2, 1 + mod(psi_, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                            C(2 * beta + 1 + index_2, 1 + mod(psi_, 2)) = C(beta + index_1, 2);
                        end
                        reduced_layer = reduced_layer + 1;
                    end
                end
                phi = phi + M;
                
                %
                %                 M = node_type_matrix(node_type_matrix_cnt, 2);
                %                 reduced_layer = log2(M);
                %                 psi = phi;
                %                 for i = 1 : reduced_layer
                %                     psi = floor(psi/2);
                %                 end
                %                 P = recursive_calc_llr(m - reduced_layer, psi, P, C(: , 1), m, lambda_offset);
                %
                %                 if mod(psi, 2) == 0
                %                     C(M : 2 * M - 1, 1) = zeros(M, 1);
                %                 else
                %                     C(M : 2 * M - 1, 2) = zeros(M, 1);
                %                     [C(:, 1), C(:, 2)] = recursive_calc_bits(m - reduced_layer, psi, C(:, 1), C(:, 2), m, lambda_offset);
                %                 end
                %                 phi = phi + M;
            case 1%RATE 1
                M = node_type_matrix(node_type_matrix_cnt, 2);
                reduced_layer = log2(M); %This reduced layer denotes where to stop.
                psi = phi;
                psi_ = phi;%This psi_ is used for bits recursion
                for i = 1 : reduced_layer
                    psi_ = floor(psi_/2);
                end
                layer = 0;%This layer denotes where to start.
                
                
                if phi ~= 0
                    while(mod(psi, 2) == 0)
                        psi = floor(psi/2);
                        layer = layer + 1;
                    end
                end
                
                if phi == 0
                    for i_layer = m - 1 : -1 : reduced_layer%NOT FULL LAYER = 0
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        for beta = 0 : index_1 - 1
                            P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                                min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                        end
                    end
                else
                    for i_layer = layer: -1 : reduced_layer
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        if i_layer == layer
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                            end
                        else
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                                    min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                            end
                        end
                    end
                end
                x_r1 = P(M : 2 * M - 1) < 0;
                if mod(psi_, 2) == 0
                    C(M : 2 * M - 1, 1) = x_r1;
                else
                    C(M : 2 * M - 1, 2) = x_r1;
                    while(mod(psi_, 2) == 1)
                        psi_ = floor(psi_/2);
                        index_1 = lambda_offset_(reduced_layer + 1);
                        index_2 = lambda_offset_(reduced_layer + 2);
                        for beta = 0 : index_1 - 1
                            C(2 * beta + index_2, 1 + mod(psi_, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                            C(2 * beta + 1 + index_2, 1 + mod(psi_, 2)) = C(beta + index_1, 2);
                        end
                        reduced_layer = reduced_layer + 1;
                    end
                end
                phi = phi + M;
                
                
                
                %                 M = node_type_matrix(node_type_matrix_cnt, 2);
                %                 reduced_layer = log2(M);
                %                 psi = phi;
                %                 for i = 1 : reduced_layer
                %                     psi = floor(psi/2);
                %                 end
                %                 P = recursive_calc_llr(m - reduced_layer, psi, P, C(: , 1), m, lambda_offset);
                %                 x_r1 = P(M : 2 * M - 1) < 0;
                %                 if mod(psi, 2) == 0
                %                     C(M : 2 * M - 1, 1) = x_r1;
                %                 else
                %                     C(M : 2 * M - 1, 2) = x_r1;
                %                     [C(:, 1), C(:, 2)] = recursive_calc_bits(m - reduced_layer, psi, C(:, 1), C(:, 2), m, lambda_offset);
                %                 end
                %                 phi = phi + M;
            case 2%REP
                M = node_type_matrix(node_type_matrix_cnt, 2);
                reduced_layer = log2(M); %This reduced layer denotes where to stop.
                psi = phi;
                psi_ = phi;%This psi_ is used for bits recursion
                for i = 1 : reduced_layer
                    psi_ = floor(psi_/2);
                end
                layer = 0;%This layer denotes where to start.
                
                
                if phi ~= 0
                    while(mod(psi, 2) == 0)
                        psi = floor(psi/2);
                        layer = layer + 1;
                    end
                end
                
                if phi == 0
                    for i_layer = m - 1 : -1 : reduced_layer%NOT FULL LAYER = 0
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        for beta = 0 : index_1 - 1
                            P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                                min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                        end
                    end
                else
                    for i_layer = layer: -1 : reduced_layer
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        if i_layer == layer
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                            end
                        else
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                                    min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                            end
                        end
                    end
                end
                x_rep = (sum(P(M : 2 * M - 1)) < 0) * ones(M , 1);
                if mod(psi_, 2) == 0
                    C(M : 2 * M - 1, 1) = x_rep;
                else
                    C(M : 2 * M - 1, 2) = x_rep;
                    while(mod(psi_, 2) == 1)
                        psi_ = floor(psi_/2);
                        index_1 = lambda_offset_(reduced_layer + 1);
                        index_2 = lambda_offset_(reduced_layer + 2);
                        for beta = 0 : index_1 - 1
                            C(2 * beta + index_2, 1 + mod(psi_, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                            C(2 * beta + 1 + index_2, 1 + mod(psi_, 2)) = C(beta + index_1, 2);
                        end
                        reduced_layer = reduced_layer + 1;
                    end
                end
                phi = phi + M;
                
                %                 M = node_type_matrix(node_type_matrix_cnt, 2);
                %                 reduced_layer = log2(M);
                %                 psi = phi;
                %                 for i = 1 : reduced_layer
                %                     psi = floor(psi/2);
                %                 end
                %                 P = recursive_calc_llr(m - reduced_layer, psi, P, C(: , 1), m, lambda_offset);
                %                 x_rep = (sum(P(M : 2 * M - 1)) < 0) * ones(M , 1);
                %                 if mod(psi, 2) == 0
                %                     C(M : 2 * M - 1, 1) = x_rep;
                %                 else
                %                     C(M : 2 * M - 1, 2) = x_rep;
                %                     [C(:, 1), C(:, 2)] = recursive_calc_bits(m - reduced_layer, psi, C(:, 1), C(:, 2), m, lambda_offset);
                %                 end
                %                 phi = phi + M;
            case 3%spc
                M = node_type_matrix(node_type_matrix_cnt, 2);
                reduced_layer = log2(M); %This reduced layer denotes where to stop.
                psi = phi;
                psi_ = phi;%This psi_ is used for bits recursion
                for i = 1 : reduced_layer
                    psi_ = floor(psi_/2);
                end
                layer = 0;%This layer denotes where to start.
                
                
                if phi ~= 0
                    while(mod(psi, 2) == 0)
                        psi = floor(psi/2);
                        layer = layer + 1;
                    end
                end
                
                if phi == 0
                    for i_layer = m - 1 : -1 : reduced_layer%NOT FULL LAYER = 0
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        for beta = 0 : index_1 - 1
                            P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                                min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                        end
                    end
                else
                    for i_layer = layer: -1 : reduced_layer
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        if i_layer == layer
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                            end
                        else
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                                    min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                            end
                        end
                    end
                end
                x_spc = SPC(P(M : 2 * M - 1));
                if mod(psi_, 2) == 0
                    C(M : 2 * M - 1, 1) = x_spc;
                else
                    C(M : 2 * M - 1, 2) = x_spc;
                    while(mod(psi_, 2) == 1)
                        psi_ = floor(psi_/2);
                        index_1 = lambda_offset_(reduced_layer + 1);
                        index_2 = lambda_offset_(reduced_layer + 2);
                        for beta = 0 : index_1 - 1
                            C(2 * beta + index_2, 1 + mod(psi_, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                            C(2 * beta + 1 + index_2, 1 + mod(psi_, 2)) = C(beta + index_1, 2);
                        end
                        reduced_layer = reduced_layer + 1;
                    end
                end
                phi = phi + M;
                
                %                 M = node_type_matrix(node_type_matrix_cnt, 2);
                %                 reduced_layer = log2(M);
                %                 psi = phi;
                %                 for i = 1 : reduced_layer
                %                     psi = floor(psi/2);
                %                 end
                %                 P = recursive_calc_llr(m - reduced_layer, psi, P, C(: , 1), m, lambda_offset);
                %                 x_spc = SPC(P(M : 2 * M - 1));
                %                 if mod(psi, 2) == 0
                %                     C(M : 2 * M - 1, 1) = x_spc;
                %                 else
                %                     C(M : 2 * M - 1, 2) = x_spc;
                %                     [C(:, 1), C(:, 2)] = recursive_calc_bits(m - reduced_layer, psi, C(:, 1), C(:, 2), m, lambda_offset);
                %                 end
                %                 phi = phi + M;
            case 4% I type
                M = node_type_matrix(node_type_matrix_cnt, 2);
                reduced_layer = log2(M); %This reduced layer denotes where to stop.
                psi = phi;
                psi_ = phi;%This psi_ is used for bits recursion
                for i = 1 : reduced_layer
                    psi_ = floor(psi_/2);
                end
                layer = 0;%This layer denotes where to start.
                
                
                if phi ~= 0
                    while(mod(psi, 2) == 0)
                        psi = floor(psi/2);
                        layer = layer + 1;
                    end
                end
                
                if phi == 0
                    for i_layer = m - 1 : -1 : reduced_layer%NOT FULL LAYER = 0
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        for beta = 0 : index_1 - 1
                            P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                                min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                        end
                    end
                else
                    for i_layer = layer: -1 : reduced_layer
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        if i_layer == layer
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                            end
                        else
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                                    min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                            end
                        end
                    end
                end
                x_typeI = typeI(P(M : 2 * M - 1));
                if mod(psi_, 2) == 0
                    C(M : 2 * M - 1, 1) = x_typeI;
                else
                    C(M : 2 * M - 1, 2) = x_typeI;
                    while(mod(psi_, 2) == 1)
                        psi_ = floor(psi_/2);
                        index_1 = lambda_offset_(reduced_layer + 1);
                        index_2 = lambda_offset_(reduced_layer + 2);
                        for beta = 0 : index_1 - 1
                            C(2 * beta + index_2, 1 + mod(psi_, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                            C(2 * beta + 1 + index_2, 1 + mod(psi_, 2)) = C(beta + index_1, 2);
                        end
                        reduced_layer = reduced_layer + 1;
                    end
                end
                phi = phi + M;
                
                
                %                 M = node_type_matrix(node_type_matrix_cnt, 2);
                %                 reduced_layer = log2(M);
                %                 psi = phi;
                %                 for i = 1 : reduced_layer
                %                     psi = floor(psi/2);
                %                 end
                %                 P = recursive_calc_llr(m - reduced_layer, psi, P, C(: , 1), m, lambda_offset);
                %                 x_typeI = typeI(P(M : 2 * M - 1));
                %                 if mod(psi, 2) == 0
                %                     C(M : 2 * M - 1, 1) = x_typeI;
                %                 else
                %                     C(M : 2 * M - 1, 2) = x_typeI;
                %                     [C(:, 1), C(:, 2)] = recursive_calc_bits(m - reduced_layer, psi, C(:, 1), C(:, 2), m, lambda_offset);
                %                 end
                %                 phi = phi + M;
            case 5% II type
                
                M = node_type_matrix(node_type_matrix_cnt, 2);
                reduced_layer = log2(M); %This reduced layer denotes where to stop.
                psi = phi;
                psi_ = phi;%This psi_ is used for bits recursion
                for i = 1 : reduced_layer
                    psi_ = floor(psi_/2);
                end
                layer = 0;%This layer denotes where to start.
                
                
                if phi ~= 0
                    while(mod(psi, 2) == 0)
                        psi = floor(psi/2);
                        layer = layer + 1;
                    end
                end
                
                if phi == 0
                    for i_layer = m - 1 : -1 : reduced_layer%NOT FULL LAYER = 0
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        for beta = 0 : index_1 - 1
                            P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                                min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                        end
                    end
                else
                    for i_layer = layer: -1 : reduced_layer
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        if i_layer == layer
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                            end
                        else
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                                    min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                            end
                        end
                    end
                end
                x_typeII = typeII(P(M : 2 * M - 1));
                if mod(psi_, 2) == 0
                    C(M : 2 * M - 1, 1) = x_typeII;
                else
                    C(M : 2 * M - 1, 2) = x_typeII;
                    while(mod(psi_, 2) == 1)
                        psi_ = floor(psi_/2);
                        index_1 = lambda_offset_(reduced_layer + 1);
                        index_2 = lambda_offset_(reduced_layer + 2);
                        for beta = 0 : index_1 - 1
                            C(2 * beta + index_2, 1 + mod(psi_, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                            C(2 * beta + 1 + index_2, 1 + mod(psi_, 2)) = C(beta + index_1, 2);
                        end
                        reduced_layer = reduced_layer + 1;
                    end
                end
                phi = phi + M;
                
                %                 M = node_type_matrix(node_type_matrix_cnt, 2);
                %                 reduced_layer = log2(M);
                %                 psi = phi;
                %                 for i = 1 : reduced_layer
                %                     psi = floor(psi/2);
                %                 end
                %                 P = recursive_calc_llr(m - reduced_layer, psi, P, C(: , 1), m, lambda_offset);
                %                 x_typeII = typeII(P(M : 2 * M - 1));
                %                 if mod(psi, 2) == 0
                %                     C(M : 2 * M - 1, 1) = x_typeII;
                %                 else
                %                     C(M : 2 * M - 1, 2) = x_typeII;
                %                     [C(:, 1), C(:, 2)] = recursive_calc_bits(m - reduced_layer, psi, C(:, 1), C(:, 2), m, lambda_offset);
                %                 end
                %                 phi = phi + M;
            case 6% III type
                M = node_type_matrix(node_type_matrix_cnt, 2);
                reduced_layer = log2(M); %This reduced layer denotes where to stop.
                psi = phi;
                psi_ = phi;%This psi_ is used for bits recursion
                for i = 1 : reduced_layer
                    psi_ = floor(psi_/2);
                end
                layer = 0;%This layer denotes where to start.
                
                
                if phi ~= 0
                    while(mod(psi, 2) == 0)
                        psi = floor(psi/2);
                        layer = layer + 1;
                    end
                end
                
                if phi == 0
                    for i_layer = m - 1 : -1 : reduced_layer%NOT FULL LAYER = 0
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        for beta = 0 : index_1 - 1
                            P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                                min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                        end
                    end
                else
                    for i_layer = layer: -1 : reduced_layer
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        if i_layer == layer
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                            end
                        else
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                                    min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                            end
                        end
                    end
                end
                x_typeIII = typeIII(P(M : 2 * M - 1));
                if mod(psi_, 2) == 0
                    C(M : 2 * M - 1, 1) = x_typeIII;
                else
                    C(M : 2 * M - 1, 2) = x_typeIII;
                    while(mod(psi_, 2) == 1)
                        psi_ = floor(psi_/2);
                        index_1 = lambda_offset_(reduced_layer + 1);
                        index_2 = lambda_offset_(reduced_layer + 2);
                        for beta = 0 : index_1 - 1
                            C(2 * beta + index_2, 1 + mod(psi_, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                            C(2 * beta + 1 + index_2, 1 + mod(psi_, 2)) = C(beta + index_1, 2);
                        end
                        reduced_layer = reduced_layer + 1;
                    end
                end
                phi = phi + M;
                
                %                 M = node_type_matrix(node_type_matrix_cnt, 2);
                %                 reduced_layer = log2(M);
                %                 psi = phi;
                %                 for i = 1 : reduced_layer
                %                     psi = floor(psi/2);
                %                 end
                %                 P = recursive_calc_llr(m - reduced_layer, psi, P, C(: , 1), m, lambda_offset);
                %                 x_typeIII = typeIII(P(M : 2 * M - 1));
                %                 if mod(psi, 2) == 0
                %                     C(M : 2 * M - 1, 1) = x_typeIII;
                %                 else
                %                     C(M : 2 * M - 1, 2) = x_typeIII;
                %                     [C(:, 1), C(:, 2)] = recursive_calc_bits(m - reduced_layer, psi, C(:, 1), C(:, 2), m, lambda_offset);
                %                 end
                %                 phi = phi + M;
            case 7% IV type
                M = node_type_matrix(node_type_matrix_cnt, 2);
                reduced_layer = log2(M); %This reduced layer denotes where to stop.
                psi = phi;
                psi_ = phi;%This psi_ is used for bits recursion
                for i = 1 : reduced_layer
                    psi_ = floor(psi_/2);
                end
                layer = 0;%This layer denotes where to start.
                
                
                if phi ~= 0
                    while(mod(psi, 2) == 0)
                        psi = floor(psi/2);
                        layer = layer + 1;
                    end
                end
                
                if phi == 0
                    for i_layer = m - 1 : -1 : reduced_layer%NOT FULL LAYER = 0
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        for beta = 0 : index_1 - 1
                            P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                                min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                        end
                    end
                else
                    for i_layer = layer: -1 : reduced_layer
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        if i_layer == layer
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                            end
                        else
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                                    min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                            end
                        end
                    end
                end
                x_typeIV = typeIV(P(M : 2 * M - 1));
                if mod(psi_, 2) == 0
                    C(M : 2 * M - 1, 1) = x_typeIV;
                else
                    C(M : 2 * M - 1, 2) = x_typeIV;
                    while(mod(psi_, 2) == 1)
                        psi_ = floor(psi_/2);
                        index_1 = lambda_offset_(reduced_layer + 1);
                        index_2 = lambda_offset_(reduced_layer + 2);
                        for beta = 0 : index_1 - 1
                            C(2 * beta + index_2, 1 + mod(psi_, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                            C(2 * beta + 1 + index_2, 1 + mod(psi_, 2)) = C(beta + index_1, 2);
                        end
                        reduced_layer = reduced_layer + 1;
                    end
                end
                phi = phi + M;
                
                %                 M = node_type_matrix(node_type_matrix_cnt, 2);
                %                 reduced_layer = log2(M);
                %                 psi = phi;
                %                 for i = 1 : reduced_layer
                %                     psi = floor(psi/2);
                %                 end
                %                 P = recursive_calc_llr(m - reduced_layer, psi, P, C(: , 1), m, lambda_offset);
                %                 x_typeIV = typeIV(P(M : 2 * M - 1));
                %                 if mod(psi, 2) == 0
                %                     C(M : 2 * M - 1, 1) = x_typeIV;
                %                 else
                %                     C(M : 2 * M - 1, 2) = x_typeIV;
                %                     [C(:, 1), C(:, 2)] = recursive_calc_bits(m - reduced_layer, psi, C(:, 1), C(:, 2), m, lambda_offset);
                %                 end
                %                 phi = phi + M;
            case 8% V type
                M = node_type_matrix(node_type_matrix_cnt, 2);
                reduced_layer = log2(M); %This reduced layer denotes where to stop.
                psi = phi;
                psi_ = phi;%This psi_ is used for bits recursion
                for i = 1 : reduced_layer
                    psi_ = floor(psi_/2);
                end
                layer = 0;%This layer denotes where to start.
                
                
                if phi ~= 0
                    while(mod(psi, 2) == 0)
                        psi = floor(psi/2);
                        layer = layer + 1;
                    end
                end
                
                if phi == 0
                    for i_layer = m - 1 : -1 : reduced_layer%NOT FULL LAYER = 0
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        for beta = 0 : index_1 - 1
                            P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                                min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                        end
                    end
                else
                    for i_layer = layer: -1 : reduced_layer
                        index_1 = lambda_offset_(i_layer + 1);
                        index_2 = lambda_offset_(i_layer + 2);
                        if i_layer == layer
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                            end
                        else
                            for beta = 0 : index_1 - 1
                                P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                                    min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                            end
                        end
                    end
                end
                x_typev = typeV(P(M : 2 * M - 1));
                if mod(psi_, 2) == 0
                    C(M : 2 * M - 1, 1) = x_typev;
                else
                    C(M : 2 * M - 1, 2) = x_typev;
                    while(mod(psi_, 2) == 1)
                        psi_ = floor(psi_/2);
                        index_1 = lambda_offset_(reduced_layer + 1);
                        index_2 = lambda_offset_(reduced_layer + 2);
                        for beta = 0 : index_1 - 1
                            C(2 * beta + index_2, 1 + mod(psi_, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                            C(2 * beta + 1 + index_2, 1 + mod(psi_, 2)) = C(beta + index_1, 2);
                        end
                        reduced_layer = reduced_layer + 1;
                    end
                end
                phi = phi + M;
                %                 M = node_type_matrix(node_type_matrix_cnt, 2);
                %                 reduced_layer = log2(M);
                %                 psi = phi;
                %                 for i = 1 : reduced_layer
                %                     psi = floor(psi/2);
                %                 end
                %                 P = recursive_calc_llr(m - reduced_layer, psi, P, C(: , 1), m, lambda_offset);
                %                 x_typeV = typeV(P(M : 2 * M - 1));
                %                 if mod(psi, 2) == 0
                %                     C(M : 2 * M - 1, 1) = x_typeV;
                %                 else
                %                     C(M : 2 * M - 1, 2) = x_typeV;
                %                     [C(:, 1), C(:, 2)] = recursive_calc_bits(m - reduced_layer, psi, C(:, 1), C(:, 2), m, lambda_offset);
                %                 end
                %                 phi = phi + M;
        end
        node_type_matrix_cnt = node_type_matrix_cnt + 1;
        if node_type_matrix_cnt == size(node_type_matrix, 1)
            node_type_matrix_cnt = 1;
        end
    else
        layer = 0;
        if phi == 0
            layer = m - 1;
        else
            psi = phi;
            while(mod(psi, 2) == 0)
                psi = floor(psi/2);
                layer = layer + 1;
            end
        end
        
        if phi == 0
            for i_layer = m - 1 : -1 : 0
                index_1 = lambda_offset_(i_layer + 1);
                index_2 = lambda_offset_(i_layer + 2);
                for beta = 0 : index_1 - 1
                    P(beta + index_1) = sign(P(2*beta + index_2)) *  sign(P(2*beta + 1 + index_2)) * ...
                        min(abs(P(2*beta + index_2)), abs(P(2*beta + 1 + index_2)));
                end
            end
        else
            for i_layer = layer: -1 : 0
                index_1 = lambda_offset_(i_layer + 1);
                index_2 = lambda_offset_(i_layer + 2);
                if i_layer == layer
                    for beta = 0 : index_1 - 1
                        P(beta + index_1) = (1 - 2*C(beta + index_1, 1)) * P(2 * beta + index_2) + P(2 * beta + 1 + index_2);
                    end
                else
                    for beta = 0 : index_1 - 1
                        P(beta + index_1) = sign(P(2 * beta + index_2)) *  sign(P(2 * beta + 1 + index_2)) * ...
                            min(abs(P(2 * beta + index_2)), abs(P(2 * beta + 1 + index_2)));
                    end
                end
            end
        end
        
        if frozen_bits(phi + 1) == 1
            C(1, 1 + mod(phi, 2)) = 0;
        else
            C(1, 1 + mod(phi, 2)) = P(1) < 0;
        end
        
        if mod(phi, 2) == 1
            layer = 0;
            psi = phi;
            while(mod(psi, 2) == 1)
                psi = floor(psi/2);
                index_1 = lambda_offset_(layer + 1);
                index_2 = lambda_offset_(layer + 2);
                for beta = 0 : index_1 - 1
                    C(2 * beta + index_2, 1 + mod(psi, 2)) = mod(C(beta + index_1, 1) + C(beta + index_1, 2), 2);
                    C(2 * beta + 1 + index_2, 1 + mod(psi, 2)) = C(beta + index_1, 2);
                end
                layer = layer + 1;
            end
        end
        
        %         P = recursive_calc_llr(m, phi, P, C(: , 1), m, lambda_offset);
        %         if frozen_bits(phi + 1) == 1
        %             C(1, mod(phi, 2) + 1) = 0;
        %         else
        %             C(1, mod(phi, 2) + 1) = P(1) < 0;
        %         end
        %
        %         if mod(phi, 2) == 1
        %             [C(:, 1), C(:, 2)] = recursive_calc_bits(m, phi, C(:, 1), C(:, 2), m, lambda_offset);
        %         end
        
        phi = phi + 1;
    end
end
x = C(end - N + 1 : end, 1);
end
