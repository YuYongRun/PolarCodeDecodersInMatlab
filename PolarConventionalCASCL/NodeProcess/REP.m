function x = REP(alpha)
x_tmp = sum(alpha) < 0;
x = x_tmp * ones(length(alpha), 1);
end