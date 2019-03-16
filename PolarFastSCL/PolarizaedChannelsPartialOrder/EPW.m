function channels = EPW(N, beta)
m = log2(N);
channels = zeros(N, 1);
for i = 0 : N - 1
    bin_seq_str = dec2bin(i, m);
    bin_seq = zeros(m, 1);
    for j = 1 : m
        if bin_seq_str(j) == '1'
            bin_seq(j) = 1;
        end
    end
    bin_seq = bin_seq(m : -1 : 1);
    sum = 0;
    for j = 1 : m
        if m >= 9
            sum = sum + bin_seq(j) * (beta^(j - 1) + 0.221 * 0.9889^(j - 1) - bin_seq(9) * 0.0371 * 0.5759^(j - 1) - bin_seq(8) * 0.047 * 0.4433^(j - 1));
        else
            if m == 8
                sum = sum + bin_seq(j) * (beta^(j - 1) + 0.221 * 0.9889^(j - 1) - bin_seq(8) * 0.047 * 0.4433^(j - 1));
            else
                sum = sum + bin_seq(j) * (beta^(j - 1) + 0.221 * 0.9889^(j - 1));
            end
        end
    end
    channels(i + 1) = sum;
end
end