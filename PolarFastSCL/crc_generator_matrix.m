function [G_parity_check_part, H_crc] = crc_generator_matrix(g, K)
%Advanced CRC parity-check generator, space efficient version.
r = length(g) - 1;
last_row = g(2 : end);
G_parity_check_part = zeros(K, r);
G_parity_check_part(K, :) = last_row;
%get non-systematic form
for i_r = r - 1 : -1 : max(r - K + 1, 1)
    G_parity_check_part(K + i_r - r, :) = [last_row(r - i_r + 1 : end), zeros(1, r - i_r)];
end
%Gaussian elimination to get systematic form
last_row_of_entire_Gcrc = [zeros(1, K - 1), g];
for j = K - 1 : -1 : 1
    num_shift = K - j;
    shifted_vec = [last_row_of_entire_Gcrc(1 + num_shift : end), zeros(1, num_shift)];
    for p = j + 1 : K
        if shifted_vec(p) == 1
            G_parity_check_part(j, :) = mod(G_parity_check_part(j, :) + G_parity_check_part(p, :), 2);
        end
    end
end
%get H_crc
H_crc = [G_parity_check_part' eye(r)];
end