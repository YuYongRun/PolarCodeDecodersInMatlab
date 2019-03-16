function UPO = partial_order_polarized_channels(N)
%N is code length, power of 2. UPO = Univeral partial order
m = log2(N);
max_connection = 32;
UPO = zeros(N, max_connection);
UPO(1, 1) = 1;
% Partial order construction
for layer = 2 : m
    N_tmp = 2^layer;
    UPO_tmp = UPO(1 : N_tmp/2, :);
    for i = 1 : N_tmp/2
        for j = 1 : max_connection
            if UPO_tmp(i, j) == 0
                break;
            else
                UPO_tmp(i, j) = UPO_tmp(i, j) + N_tmp/2;
            end
        end
    end
    UPO(N_tmp/2 + 1 : N_tmp, :) = UPO_tmp;
    for i = N_tmp/4 + 1 : N_tmp/2
        for j = 1 : max_connection
            if UPO(i, j) == 0
                UPO(i, j) = (i - 1) + N_tmp/4;
                break;
            end
        end
    end
end
%Delete redundant all zero columns
while(all(UPO(:, end) == 0))
    UPO(:, end) = [];
end