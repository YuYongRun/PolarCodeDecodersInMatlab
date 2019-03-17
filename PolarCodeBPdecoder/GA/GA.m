function [u, ave_iter] = GA(sigma, N)
%ave_iter用来统计为了求零点 牛顿法平均要迭代多少次
u = zeros(1, N);
u(1) = 2/sigma^2;
num_for_runs = 0;
sum_iter = 0;
for i = 1:log2(N)
    j = 2^(i - 1);
    for k = 1:j
        tmp = u(k);
        [u(k), num_iter] = phi_inverse(1 - (1 - phi(tmp))^2);
        sum_iter = sum_iter + num_iter;
        u(k + j) = 2 * tmp;
        num_for_runs = num_for_runs + 1;
    end
end
u = bitrevorder(u);
ave_iter = sum_iter/num_for_runs;
end
