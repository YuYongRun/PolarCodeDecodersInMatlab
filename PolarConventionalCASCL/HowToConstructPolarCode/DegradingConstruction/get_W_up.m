function W_up = get_W_up(W)
N = size(W, 2);
W_up = zeros(2, N^2);
for u1 = 0 : 1
    for y1 = 1 : N
        for y2 = 1 : N
            W_up(u1 + 1, N * (y1 - 1) + y2) = 0.5 * (W(u1 + 1, y1) * W(1, y2) + W(mod(u1 + 1, 2) + 1, y1) * W(2, y2));
        end
    end
end
end