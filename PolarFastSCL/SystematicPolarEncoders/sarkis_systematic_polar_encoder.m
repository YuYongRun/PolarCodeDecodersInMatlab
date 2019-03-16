function x = sarkis_systematic_polar_encoder(u, info_bits, frozen_bits, N, lambda_offset, llr_layer_vec)
x = zeros(N, 1);
%First step encoding
x(info_bits) = u;
x = polar_encoder(x, lambda_offset, llr_layer_vec);
%Second step encoding
x(frozen_bits) = 0;
x = polar_encoder(x, lambda_offset, llr_layer_vec);
end

