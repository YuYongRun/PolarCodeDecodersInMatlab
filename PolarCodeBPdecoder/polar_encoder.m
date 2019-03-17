function x = polar_encoder(u, lambda_offset, llr_layer_vec)
%encoding: x = u * Fn.
N = length(u);
m = log2(N);
C = zeros(N - 1, 1);
x = zeros(N, 1);
for phi = 0 : N - 1
    switch phi
        case 0
            index_1 = lambda_offset(m);
            for beta = 1 : index_1
                C(beta + index_1 - 1) = u(beta) + u(beta + index_1);
            end
            for i_layer = m - 2 : -1 : 0
                index_1 = lambda_offset(i_layer + 1);
                index_2 = lambda_offset(i_layer + 2);
                for beta = index_1 : index_2 - 1
                    C(beta) = C(beta + index_1) + C(beta + index_2);
                end
            end
        case N/2
            index_1 = lambda_offset(m);
            for beta = 1 : index_1
                C(beta + index_1 - 1) = u(beta + index_1);
            end
            for i_layer = m - 2 : -1 : 0
                index_1 = lambda_offset(i_layer + 1);
                index_2 = lambda_offset(i_layer + 2);
                for beta = index_1 : index_2 - 1
                    C(beta) = C(beta + index_1) + C(beta + index_2);
                end
            end
        otherwise
            layer = llr_layer_vec(phi + 1);
            index_1 = lambda_offset(layer + 1);
            index_2 = lambda_offset(layer + 2);
            for beta = index_1 : index_2 - 1
                C(beta) = C(beta + index_2);
            end
            for i_layer = layer - 1: -1 : 0
                index_1 = lambda_offset(i_layer + 1);
                index_2 = lambda_offset(i_layer + 2);
                for beta = index_1 : index_2 - 1
                    C(beta) = C(beta + index_1) + C(beta + index_2);
                end
            end
    end
    x(phi + 1) = C(1);
end
x = mod(x, 2);
end