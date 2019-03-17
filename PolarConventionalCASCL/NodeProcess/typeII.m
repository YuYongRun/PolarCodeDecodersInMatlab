function x = typeII(alpha)
N = length(alpha);
x_tmp_4 = zeros(4, 1);

sum_alpha_1 = sum(alpha(1 : end/4));
x_tmp_4(1) = sum_alpha_1 < 0;

sum_alpha_2 = sum(alpha(end/4 + 1 : end/2));
x_tmp_4(2) = sum_alpha_2 < 0;

sum_alpha_3 = sum(alpha(end/2 + 1 : end * 3/4));
x_tmp_4(3) = sum_alpha_3 < 0;

sum_alpha_4 = sum(alpha(end * 3/4 + 1 : end));
x_tmp_4(4) = sum_alpha_4 < 0;

if mod(sum(x_tmp_4(2 : 4)), 2) ~= x_tmp_4(1)
    abs_sum_alpha = [abs(sum_alpha_1) abs(sum_alpha_2) abs(sum_alpha_3) abs(sum_alpha_4)];
    index_vec = (abs_sum_alpha == min(abs_sum_alpha));
    x_tmp_4(index_vec) = mod(x_tmp_4(index_vec) + 1, 2);
end
x_tmp = [x_tmp_4(1) * ones(1, N/4) x_tmp_4(2) * ones(1, N/4) x_tmp_4(3) * ones(1, N/4) x_tmp_4(4) * ones(1, N/4)];
x = x_tmp';
end