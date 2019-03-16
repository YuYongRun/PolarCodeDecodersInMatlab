function y = get_y_interval(sigma, alpha)
y = zeros(size(alpha, 1) - 1, 2);
for i = 1 : size(alpha, 1) - 1
    y(i, 1) = sigma^2/2*log(alpha(i));
    y(i, 2) = sigma^2/2*log(alpha(i + 1));
end
end