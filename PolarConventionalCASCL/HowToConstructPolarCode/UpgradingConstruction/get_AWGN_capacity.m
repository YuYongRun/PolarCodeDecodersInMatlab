function C = get_AWGN_capacity(a, sigma)
%This function is employed here to verify the correctness of the program
%that is being writen
f1 = @(y, a, sigma) 0.5/sqrt(2*pi)/sigma*exp(-(y - a).^2/2/sigma^2) .* ...
                    (1 - log2((1 + exp(-2*a/sigma^2*y))));

C0 = integral(@(y)f1(y, a, sigma), -30,1000);

f2 = @(y, a, sigma) 0.5/sqrt(2*pi)/sigma*exp(-(y + a).^2/2/sigma^2) .* ...
                    (1 - log2((1 + exp(2*a*y/sigma^2))));
C1 = integral(@(y)f2(y, a, sigma), -1000,30);

C = C0 + C1;

end
%CAUTION£¡DO NOT USE quad()!