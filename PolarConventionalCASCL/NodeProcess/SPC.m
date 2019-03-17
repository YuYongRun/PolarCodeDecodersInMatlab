function x = SPC(alpha)%Wagner Decoder
x = alpha < 0;
if mod(sum(x(2 : end)), 2) ~= x(1)
    alpha_plus = abs(alpha);
    x(alpha_plus == min(alpha_plus)) = mod(x(alpha_plus == min(alpha_plus)) + 1, 2);
end
end