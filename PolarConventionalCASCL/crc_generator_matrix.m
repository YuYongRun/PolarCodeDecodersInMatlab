function [G, H] = crc_generator_matrix(g, K)
% [1 1 1 0 1 0 1 0 1] can be used for test
r = length(g) - 1;
N = K + r;
zero_fill = zeros(1, K - 1);
G = zeros(K, N);
G(end, :) = [zero_fill g];
for i = K - 1 : -1 : 1
    G(i, :) = [G(i + 1, 2 : end), G(i + 1, 1)];
end
for i = K - 1 : -1 : 1
    for j = N - r : -1 : i + 1
        if G(i, j) == 1
            G(i, :) = mod(G(i, :) + G(j, :), 2);
        end
    end
end
H = zeros(r, N);
H(:, 1 : K) = G(:, K + 1 : end)';
H(:, K + 1 : end) = eye(r);