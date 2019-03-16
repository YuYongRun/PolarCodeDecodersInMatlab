function dx = derivative_phi(x)
if (x >= 0)&&(x <= 10)
    dx = -0.4527*0.86*x^(-0.14)*phi(x);
else
    dx = exp(-x/4)*sqrt(pi/x)*(-1/2/x*(1 - 10/7/x) - 1/4*(1 - 10/7/x) + 10/7/x/x);
end
end