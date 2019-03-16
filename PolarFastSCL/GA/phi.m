function y = phi(x)
if (x >= 0)&&(x <= 10)
    y = exp(-0.4527*x^0.859 + 0.0218);
else
    y = sqrt(pi/x) * exp(-x/4) * (1 - 10/7/x);
end