function V = erasure_symbol_merge(W)
cnt = 0;
N = size(W, 2);
for i = N/2 : -1  : 1
    if W(1, i) == W(2, i)
        cnt = cnt + 1;
    else
        break;
    end
end

W_erasure = W(:, N/2 - cnt + 1 : N/2 + cnt);
erasure_probability = sum(W_erasure(1, :));
middle = erasure_probability/2 * ones(2, 2);
W_left = W(:, 1 : N/2 - cnt);
W_right = W(:, N/2 + cnt + 1 : end);
V = [W_left middle W_right];
end