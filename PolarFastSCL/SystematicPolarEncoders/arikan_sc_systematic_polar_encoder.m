function x = arikan_sc_systematic_polar_encoder(u, frozen_bits, info_bits, lambda_offset, llr_layer_vec, bit_layer_vec)
N = length(frozen_bits);
y = zeros(N, 1);
llr = 1 - 2 * u;
y(info_bits) = llr;
x = SC_systematic_encoder(y, frozen_bits, lambda_offset, llr_layer_vec, bit_layer_vec);
end

