function z = delta_capacity_lemma11(a1, a2, a3, b1, b2, b3)
I1 = -delta_capacity_basic(a1, b1);
I2 = -delta_capacity_basic(a2, b2);
I3 = -delta_capacity_basic(a3, b3);

lambda1 = a1/b1;

if a3/b3 < inf
    lambda3 = a3/b3;
    alpha1 = lambda1 * (lambda3 * b2 - a2) / (lambda3 - lambda1);
    beta1 = (lambda3 * b2 - a2) / (lambda3 - lambda1);
    alpha3 = lambda3 * (a2 - lambda1 * b2) / (lambda3 - lambda1);
    beta3 = (a2 - lambda1 * b2) / (lambda3 - lambda1);
else
    alpha1 = lambda1 * b2;
    beta1 = b2;
    alpha3 = a2 - lambda1 * b2;
    beta3 = 0;
end
I4 = delta_capacity_basic(a3 + alpha3, b3 + beta3);
I5 = delta_capacity_basic(a1 + alpha1, b1 + beta1);

z = I1 + I2 + I3 + I4 + I5;

end