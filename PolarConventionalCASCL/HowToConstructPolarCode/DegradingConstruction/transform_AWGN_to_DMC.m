function W = transform_AWGN_to_DMC(y, sigma, v)
W = zeros(2, 2 * v);
for i = 1 : v
    y_min = y(i, 1);
    y_max = y(i, 2);
    p0 = normcdf(y_max, 1, sigma) - normcdf(y_min, 1, sigma);
    p1 = normcdf(y_max, -1, sigma) - normcdf(y_min, -1, sigma);
    W(1, 2*i - 1) = p0;
    W(2, 2*i - 1) = p1;
    W(1, 2*i) = p1;
    W(2, 2*i) = p0;
end
    
    