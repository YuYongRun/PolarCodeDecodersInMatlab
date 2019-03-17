function alpha = get_Clambda_zero_points(v)
alpha = zeros(v + 1, 1);
alpha(1) = 1;
alpha(v + 1) = realmax;
%above two values are obtained by simple calculations and avoid numerical
%problems
%Newton descend method
epsilon = 1e-6;%tolerance error
for i = 2 : v
    beta = (i - 1)/v;
    x0 = 0;
    x1 = 1.5;%initial point, the zero point of d^2C(lambda)/x^2
    while(abs(x0 - x1) > epsilon)
        x0 = x1;
        x1 = x0 - (Clambda(x0) - beta)/dClambdadx(x0);
    end
    alpha(i) = x1;
end

end
        