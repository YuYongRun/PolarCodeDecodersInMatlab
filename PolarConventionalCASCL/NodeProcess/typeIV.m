function x = typeIV(alpha)
%4 times of Bit-wise MAP
alpha_1 = alpha(1 : end/4);
% llr_1 = 2*atanh(prod(tanh(alpha_1/2)));
llr_1 = prod(sign(alpha_1))*min(abs(alpha_1));

alpha_2 = alpha(end/4 + 1 : end/2);
% llr_2 = 2*atanh(prod(tanh(alpha_2/2)));
llr_2 = prod(sign(alpha_2))*min(abs(alpha_2));

alpha_3 = alpha(end/2 + 1 : end*3/4);
% llr_3 = 2*atanh(prod(tanh(alpha_3/2)));
llr_3 = prod(sign(alpha_3))*min(abs(alpha_3));

alpha_4 = alpha(end*3/4 + 1 : end);
% llr_4 = 2*atanh(prod(tanh(alpha_4/2)));
llr_4 = prod(sign(alpha_4))*min(abs(alpha_4));


%Even Parity check
check_bit = (llr_1 + llr_2 + llr_3 + llr_4) < 0;
%Wagner Decoder
x1 = alpha_1 < 0;
if mod(sum(x1), 2) ~= check_bit
    x1(abs(alpha_1) == min(abs(alpha_1))) = mod(x1(abs(alpha_1) == min(abs(alpha_1))) + 1, 2);
end

x2 = alpha_2 < 0;
if mod(sum(x2), 2) ~= check_bit
    x2(abs(alpha_2) == min(abs(alpha_2))) = mod(x2(abs(alpha_2) == min(abs(alpha_2))) + 1, 2);
end

x3 = alpha_3 < 0;
if mod(sum(x3), 2) ~= check_bit
    x3(abs(alpha_3) == min(abs(alpha_3))) = mod(x3(abs(alpha_3) == min(abs(alpha_3))) + 1, 2);
end

x4 = alpha_4 < 0;
if mod(sum(x4), 2) ~= check_bit
    x4(abs(alpha_4) == min(abs(alpha_4))) = mod(x4(abs(alpha_4) == min(abs(alpha_4))) + 1, 2);
end

x_tmp = [x1; x2; x3; x4];

x = x_tmp(:);

end