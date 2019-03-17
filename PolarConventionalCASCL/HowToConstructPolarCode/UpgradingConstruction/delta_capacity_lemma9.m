function z = delta_capacity_lemma9(a1, a2, b1, b2)
I1 = -delta_capacity_basic(a1, b1);
I2 = -delta_capacity_basic(a2, b2);

if a2/b2 < inf
    lambda2 = a2/b2;
    alpha2 = lambda2 * (a1 + b1)/(lambda2 + 1);
    beta2 = (a1 + b1)/(lambda2 + 1);
else
    alpha2 = a1 + b1;
    beta2 = 0;
end

I3 = delta_capacity_basic(a2 + alpha2, b2 + beta2);

z = I1 + I2 + I3;

end