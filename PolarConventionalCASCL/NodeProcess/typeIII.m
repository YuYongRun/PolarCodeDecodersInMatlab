function x = typeIII(alpha)
alpha_first_half = alpha(1 : end/2);
alpha_second_half = alpha(end/2 + 1 : end);
x0 = alpha_first_half < 0;
x1 = alpha_second_half < 0;
if mod(sum(x0(2 : end)), 2) ~= x0(1)
    abs_alpha_first_half = abs(alpha_first_half);
    index_vec = abs_alpha_first_half == min(abs_alpha_first_half);
    x0(index_vec) = mod(x0(index_vec) + 1, 2);
end
if mod(sum(x1(2 : end)), 2) ~= x1(1)
    abs_alpha_second_half = abs(alpha_second_half);
    index_vec = abs_alpha_second_half == min(abs_alpha_second_half);
    x1(index_vec) = mod(x1(index_vec) + 1, 2);
end
x_tmp = [x0; x1];
x = x_tmp(:);
end