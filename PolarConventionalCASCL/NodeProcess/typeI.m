function x = typeI(alpha)
N = length(alpha);
x0 = sum(alpha(1 : end/2)) < 0;
x1 = sum(alpha(end/2 + 1 : end)) < 0;
x_tmp = [x0 * ones(1, N/2) x1 * ones(1, N/2)];
x = x_tmp';
end