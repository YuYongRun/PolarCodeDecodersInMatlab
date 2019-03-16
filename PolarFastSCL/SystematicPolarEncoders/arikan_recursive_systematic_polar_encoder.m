function x = arikan_recursive_systematic_polar_encoder(input_vec, info_bits)
%info_bits is an N*1 vector. info_bits(i) = 1 means u_i is an
%information bit, otherwise a frozen bit.

%part 1: input_vec(info_bits) is information bit vec.

%part 2: input_vec(frozen_bits) can be initilaized arbitrarily. The value
%of input_vec(frozen_bits) does not affect encoding, even if
%input_vec(frozen_bits) is NaN.

%Arikan's recursive method
%although this method is low-complexity, it is not that good for MATLAB
%implementation. It is too slow.
N = length(info_bits);
sum_info_bits = sum(info_bits);
switch sum_info_bits
    case N
        x = input_vec;
    case 0
        x = zeros(N, 1);
    otherwise
        index_1 = 1 : N/2;
        index_2 = N/2 + 1 : N;
        A1 = info_bits(index_1);
        A2 = info_bits(index_2);
        input_vec_1 = input_vec(index_1);%the first half
        input_vec_2 = input_vec(index_2);%the second half
        x2 = arikan_recursive_systematic_polar_encoder(input_vec_2, A2);
        input_vec_1 = mod(input_vec_1 + x2, 2);
        x1 = arikan_recursive_systematic_polar_encoder(input_vec_1, A1);
        x1 = mod(x1 + x2, 2);
        x = [x1; x2];
end
end

