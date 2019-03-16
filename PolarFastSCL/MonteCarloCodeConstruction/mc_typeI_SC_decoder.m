function ber = mc_typeI_SC_decoder(llr, lambda_offset, llr_layer_vec, bit_layer_vec, dummy_info)%x is code word, not sorcue seq.
N = length(llr);
m = log2(N);
P = zeros(N - 1, 1);%llr is not include in P.
C = zeros(N - 1, 2); %I do not calculate the estimate of (x1, x2, ... , xN). It is not very necessary.
ber = zeros(N, 1);
for phi = 0 : N - 1 
    switch phi
        case 0
            for i_layer = m - 1 : -1 : 0
                index_1 = lambda_offset(i_layer + 1);
                if i_layer == (m - 1)
                    for beta = 0 : index_1 - 1
                        sign_1 = sign(llr(2 * beta + 1));
                        sign_2 = sign(llr(2 * beta + 2));
                        a = abs(llr(2 * beta + 1));
                        b = abs(llr(2 * beta + 2));
                        P(beta + index_1) =  sign_1 * sign_2 * min(a, b);
                    end
                else
                    for beta = index_1 : 2 * index_1 - 1
                        sign_1 = sign(P(2 * beta));
                        sign_2 = sign(P(2 * beta + 1));
                        a = abs(P(2 * beta));
                        b = abs(P(2 * beta + 1));
                        P(beta) =  sign_1 * sign_2 * min(a, b);
                    end
                end
            end
        case N/2
            for i_layer = m - 1 : -1 : 0
                index_1 = lambda_offset(i_layer + 1);
                if i_layer == (m - 1)
                    for beta = 0 : index_1 - 1
                        a = llr(2 * beta + 1);
                        b = llr(2 * beta + 2);
                        P(beta + index_1) = (1 - 2 * C(beta + index_1, 1)) * a + b;
                    end
                else
                    for beta = index_1 : 2 * index_1 - 1
                        sign_1 = sign(P(2 * beta));
                        sign_2 = sign(P(2 * beta + 1));
                        a = abs(P(2 * beta));
                        b = abs(P(2 * beta + 1));
                        P(beta) =  sign_1 * sign_2 * min(a, b);
                    end
                end
            end
        otherwise
            layer = llr_layer_vec(phi + 1);
            for i_layer = layer: -1 : 0
                index_1 = lambda_offset(i_layer + 1);
                switch i_layer
                    case layer
                        for beta = index_1 : 2 * index_1 - 1
                            P(beta) = (1 - 2 * C(beta, 1)) * P(2 * beta) + P(2 * beta + 1);
                        end
                    otherwise
                        for beta = index_1 : 2 * index_1 - 1
                            sign_1 = sign(P(2 * beta));
                            sign_2 = sign(P(2 * beta + 1));
                            a = abs(P(2 * beta));
                            b = abs(P(2 * beta + 1));
                            P(beta) =  sign_1 * sign_2 * min(a, b);
                        end
                end
            end
    end
    
    phi_mod_2 = mod(phi, 2);
    
    C(1, 1 + phi_mod_2) = dummy_info(phi + 1);
    
    if ((P(1) < 0) && (dummy_info(phi + 1) == 0)) || ((P(1) >= 0) && (dummy_info(phi + 1) == 1))
        ber(phi + 1) = 1;
    end

    
    if (phi_mod_2)  == 1 && (phi ~= (N - 1))
        layer = bit_layer_vec(phi + 1);
        for i_layer = 0 : layer
            index_1 = lambda_offset(i_layer + 1);
            if i_layer == layer
                for beta = index_1 : 2 * index_1 - 1
                    C(2 * beta, 1) = mod(C(beta, 1) + C(beta, 2), 2);
                    C(2 * beta + 1, 1) = C(beta, 2);
                end
            else
                for beta = index_1 : 2 * index_1 - 1
                    C(2 * beta, 2) = mod(C(beta, 1) + C(beta, 2), 2);
                    C(2 * beta + 1, 2) = C(beta, 2);
                end
            end
        end
    end
    
end
end