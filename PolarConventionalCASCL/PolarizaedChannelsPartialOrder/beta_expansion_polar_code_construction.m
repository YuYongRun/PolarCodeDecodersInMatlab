function channels = beta_expansion_polar_code_construction(N, beta)
m = log2(N);
channels = zeros(N, 1);
for i = 0 : N - 1
    bin_seq = dec2bin(i, m);
    sum = 0;
    for j = 1 : m
        if bin_seq(j) == '1'
            sum = sum + beta^(m - j);
        end
    end
    channels(i + 1) = sum;
end
end