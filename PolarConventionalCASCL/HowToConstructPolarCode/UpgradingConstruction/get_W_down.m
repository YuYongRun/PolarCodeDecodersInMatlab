function W_down = get_W_down(W)
N = size(W, 2);
W_down = zeros(2, 2 * N^2);
for u2 = 0 : 1
    for y1 = 1 : N
        for y2 = 1 : N
            for u1 = 0 : 1
%                 P = 0.5 * W(mod(u1 + u2, 2) + 1, y1) * W(u2 + 1, y2);
%                 if P == 0
%                     W_down(u2 + 1, 2 * N * (y1 - 1) + 2 * (y2 - 1) + u1 + 1) = realmin;
%                 else
%                     W_down(u2 + 1, 2 * N * (y1 - 1) + 2 * (y2 - 1) + u1 + 1) = P;
%                 end
                W_down(u2 + 1, 2 * N * (y1 - 1) + 2 * (y2 - 1) + u1 + 1) = 0.5 * W(mod(u1 + u2, 2) + 1, y1) * W(u2 + 1, y2);
            end
        end
    end
end
end
