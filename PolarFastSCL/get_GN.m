function FN = get_GN(N)
F = [1, 0 ; 1, 1];
FN = zeros(N, N);
FN(1 : 2, 1 : 2) = F;
for i = 2 : log2(N)
    FN(1 : 2^i, 1 : 2^i) = kron(FN(1 : 2^(i - 1), 1 : 2^(i - 1)), F);
end