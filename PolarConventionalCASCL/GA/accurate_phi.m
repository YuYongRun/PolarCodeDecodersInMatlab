function z = accurate_phi(x)
f = @(u, x) (exp(u) - 1)./(exp(u) + 1) .* exp(-(u - x).^2./4./x);
z = integral(@(u) f(u, x), -100, 100);
z = 1 - 1/sqrt(4 * pi * x) * z;
end