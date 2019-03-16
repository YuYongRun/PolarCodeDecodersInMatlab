function V = LR_sort(W)
N = size(W, 2);
LLR = zeros(1, N);
for i = 1 : N
    if (W(1, i) ~= 0) && (W(2, i) ~= 0)
        LLR(i) = log(W(1, i)) - log(W(2, i));
    else
        if (W(1, i) == 0) && (W(2, i) ~= 0)
            LLR(i) = -inf;
        else
            if (W(1, i) ~= 0) && (W(2, i) == 0)
                LLR(i) = inf;
            end
        end
    end
end
[~, ordered]  = sort(LLR, 'descend');
V = W(:, ordered);
end