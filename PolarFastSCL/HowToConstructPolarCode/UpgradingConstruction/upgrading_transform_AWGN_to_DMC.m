function W = upgrading_transform_AWGN_to_DMC(y, theta, sigma, v)
W = zeros(2, 2 * v);
for i = 1 : v
    if i < v
        y_min = y(i, 1);
        y_max = y(i, 2);
        p0 = normcdf(y_max, 1, sigma) - normcdf(y_min, 1, sigma);
        p1 = normcdf(y_max, -1, sigma) - normcdf(y_min, -1, sigma);
        pi_i = p0 + p1;
        z0 = (theta(i + 1) * pi_i)/(1 + theta(i + 1));
        z1 = pi_i/(1 + theta(i + 1));
        W(1, 2*i - 1) = z0;
        W(2, 2*i - 1) = z1;
        W(1, 2*i) = z1;
        W(2, 2*i) = z0;
    else
        y_min = y(i, 1);
        y_max = y(i, 2);
        p0 = normcdf(y_max, 1, sigma) - normcdf(y_min, 1, sigma);
        p1 = normcdf(y_max, -1, sigma) - normcdf(y_min, -1, sigma);
        pi_i = p0 + p1;
        W(1, 2*i - 1) = pi_i;
        W(2, 2*i - 1) = 0;
        W(1, 2*i) = 0;
        W(2, 2*i) = pi_i;
    end
end

