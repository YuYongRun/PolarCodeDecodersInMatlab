function [info_esti, denoised_llr, error, iter_this_time] = BP_Decoder_LLR(info_bits, frozen_bits, llr, max_iter, M_right_up, M_right_down)
N = length(frozen_bits);
n = log2(N);
R = zeros(N, n + 1);
L = zeros(N, n + 1);
internal_bits = zeros(N, n + 1);
%Initialize R
for i = 1:N
    if frozen_bits(i) == 1
        R(i, 1) = realmax;
    end
end
%Initialize L
L(:, n + 1) = llr;
%Iter
for iter = 1 : max_iter
    %Left Prop
    for j = n : -1 : 1 %for each layer
        for i = 1 : N/2 %for each 2*2 module in each layer
            up_index = M_right_up(i, j);
            down_index = M_right_down(i, j);
            R_up_j = R(up_index, j);
            R_down_j = R(down_index, j);
            L_up_j_plus_1 = L(up_index, j + 1);
            L_down_j_plus_1 = L(down_index, j + 1);
            L(up_index, j) = 0.9375 * sign(R_down_j + L_down_j_plus_1) * sign(L_up_j_plus_1) * min(abs(R_down_j + L_down_j_plus_1), abs(L_up_j_plus_1));
            L(down_index, j) = 0.9375 * sign(R_up_j) * sign(L_up_j_plus_1) * min(abs(R_up_j), abs(L_up_j_plus_1)) + L_down_j_plus_1;
        end
    end
    u_esti = (L(:, 1) + R(:, 1)) < 0;
    internal_bits(:, 1) =  u_esti;
    %Right Prop
    for j = 1 : n
        for i = 1 : N/2
            up_index = M_right_up(i, j);
            down_index = M_right_down(i, j);
            R_up_j = R(up_index, j);
            R_down_j = R(down_index, j);
            L_up_j_plus_1 = L(up_index, j + 1);
            L_down_j_plus_1 = L(down_index, j + 1);
            R(up_index, j + 1) = 0.9375 * sign(R_down_j + L_down_j_plus_1) * sign(R_up_j) * min(abs(R_down_j + L_down_j_plus_1), abs(R_up_j));
            R(down_index, j + 1) = 0.9375 * sign(R_up_j) * sign(L_up_j_plus_1) * min(abs(R_up_j), abs(L_up_j_plus_1)) + R_down_j;
            internal_bits(up_index, j + 1) = mod(internal_bits(up_index, j) + internal_bits(down_index, j), 2);
            internal_bits(down_index, j + 1) = internal_bits(down_index, j);
        end
    end
    x_esti = (L(:, n + 1) + R(:, n + 1)) < 0;
    x_enc = internal_bits(:, n + 1);
    if all(x_esti == x_enc)
        info_esti = u_esti(info_bits);
        denoised_llr = L(:, n + 1) + R(:, n + 1);
        error = 0;
        iter_this_time = iter;
        break;
    else
        if iter == max_iter
            info_esti = u_esti(info_bits);
            denoised_llr = L(:, n + 1) + R(:, n + 1);
            error = 1;
            iter_this_time = iter;
        end
    end
end
end