function [M_right_up, M_right_down] = index_Matrix(N)
n = log2(N);
M_right_up = zeros(N/2, n);
M_right_down = zeros(N/2, n);
for i = 1 : n
    for j = 1 : 2^(i - 1)
        M_right_up((j - 1) * N/2^i + 1 : j * N/2^i, i) = (1 : N/2^i)' + (j - 1) * N/2^(i - 1);
    end
    M_right_down(:, i) = M_right_up(:, i) + 2^(n - i);
end
M_right_up = M_right_up(:, end : -1 : 1);
M_right_down = M_right_down(:, end : -1 : 1);



                