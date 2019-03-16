function [bler, ber] = simulation(N, K, design_epsilon, max_runs, max_err, resolution, ebno_vec, list_size_vec, g, crc_length)
R = (K - crc_length)/N;
lambda_offset = 2.^(0 : log2(N));
llr_layer_vec = get_llr_layer(N);
bit_layer_vec = get_bit_layer(N);
[G_crc, H_crc] = crc_generator_matrix(g, K - crc_length);
crc_parity_check = G_crc';
 
%beta expansion Code Construction, proposed by Huawei
% beta = sqrt(sqrt(2));
% % channels = PW(N, beta);
% % channels = HPW(N, beta);
% channels = EPW(N, beta);
% [~, channel_ordered] = sort(channels, 'descend');
% info_bits = sort(channel_ordered(1 : K));
% frozen_bits = ones(N , 1);
% frozen_bits(info_bits) = 0;

%Bhattacharyya Code (BEC) Construction
% channels = get_BEC_IWi(N, design_epsilon);
% [~, channel_ordered] = sort(channels, 'descend');
% info_bits = sort(channel_ordered(1 : K), 'ascend');
% frozen_bits = ones(N , 1);
% frozen_bits(info_bits) = 0;
% info_bits_logical = logical(mod(frozen_bits + 1, 2));

%Gaussian approximation Code Construction
design_snr = 2.5;
sigma_cc = 1/sqrt(2 * R) * 10^(-design_snr/20);
[channels, ~] = GA(sigma_cc, N);
[~, channel_ordered] = sort(channels, 'descend');
info_bits = sort(channel_ordered(1 : K), 'ascend');
frozen_bits = ones(N, 1);
frozen_bits(info_bits) = 0;
frozen_bits = logical(frozen_bits);

%Following MATLAB code is used for matrix-multiplication based systematic polar encoding
FN = get_GN(N);
GAA = FN(info_bits, info_bits);
GAAC = FN(info_bits, frozen_bits);
Generate_xAC = mod(GAAC' * GAA', 2);
systematic_encoding_algorithm = 1; 

%This value can be 1, 2, 3, and 4.
%1 : 'Matrix_multiplication_systematic_encoder' 
%!!!!But when N is large,the Generator matrix will be large, too. The computer may not have such large storage.
%2 : 'Sarkis_Two_step_systematic_encoder'
%3 : 'Arikan_SC_style_systematic_encoder'
%4 : 'Arikan_Recursive_systematic_encoder'. This one is slow.

%Special constituent nodes
node_type_matrix = get_node_structure(frozen_bits);
psi_vec = get_psi_for_advanced_sc_decoder(node_type_matrix);

%Results Stored
bler = zeros(length(ebno_vec), length(list_size_vec));
num_runs = zeros(length(ebno_vec), length(list_size_vec));
ber = zeros(length(ebno_vec), length(list_size_vec));
%Loop starts
tic
for i_run = 1 : max_runs
    if  mod(i_run, max_runs/resolution) == 1
        disp(' ');
        disp(['Sim iteration running = ' num2str(i_run)]);
        disp(['N = ' num2str(N) ' K = ' num2str(K)]);
        disp(['List size = ' num2str(list_size_vec)]);
        disp('Current block error performance');
        disp(num2str([ebno_vec'  bler./num_runs]));
        disp('Current bit error performance');
        disp(num2str([ebno_vec'  ber./num_runs/K]));
        disp(' ')
    end
    info  = rand(K - crc_length, 1) > 0.5;
    info_with_crc = [info; mod(crc_parity_check * info, 2)];
    switch systematic_encoding_algorithm
        case 1
            parity_check_bits = mod(Generate_xAC * info_with_crc, 2);
            x = zeros(N, 1);
            x(info_bits) = info_with_crc;
            x(frozen_bits) = parity_check_bits;
        case 2
            x = sarkis_systematic_polar_encoder(info_with_crc, info_bits, frozen_bits, N, lambda_offset, llr_layer_vec);
        case 3
            x = arikan_sc_systematic_polar_encoder(info_with_crc, frozen_bits, info_bits, lambda_offset, llr_layer_vec, bit_layer_vec);
        case 4
            x = zeros(N, 1);
            x(info_bits) = info_with_crc;
            x = arikan_recursive_systematic_polar_encoder(x, mod(frozen_bits + 1, 2));
    end
    bpsk = 1 - 2 * x;
    noise = randn(N, 1);
    prev_decoded = zeros(length(ebno_vec), length(list_size_vec));
    for i_ebno = 1 : length(ebno_vec)
        sigma = 1/sqrt(2 * R) * 10^(-ebno_vec(i_ebno)/20);
        y = bpsk + sigma * noise;
        llr = 2/sigma^2*y;
        %*******Simulaion Accelaration*********
        for i_list = 1 : length(list_size_vec)
            if i_list ~= 1
                if bler(i_ebno, i_list) == max_err
                    continue;
                end
            else
                if all(bler(i_ebno, 2 : end) == max_err)
                    continue
                end
            end
            num_runs(i_ebno, i_list) = num_runs(i_ebno, i_list) + 1;
            run_sim = 1;
            for i_ebno2 = 1 : i_ebno
                for i_list2 = 1 : i_list
                    if prev_decoded(i_ebno2, i_list2)
                        run_sim = 0;
                    end
                end
            end
            if run_sim == 0
                continue;
            end
            %*******Simulaion Accelaration*********
            if list_size_vec(i_list) == 1
                polar_info_esti = SC_decoder(llr, frozen_bits, lambda_offset, llr_layer_vec, bit_layer_vec, info_bits);
%                 polar_info_esti = FastSCdecoder(llr, info_bits, node_type_matrix, lambda_offset, llr_layer_vec, psi_vec, bit_layer_vec);
            else
                polar_info_esti = FastSCL_decoder(llr, list_size_vec(i_list), info_bits, lambda_offset, llr_layer_vec, bit_layer_vec, psi_vec, node_type_matrix, H_crc);
            end
            if any(polar_info_esti ~= info_with_crc)
                bler(i_ebno, i_list) = bler(i_ebno, i_list) + 1;
                ber(i_ebno, i_list) = ber(i_ebno, i_list) + sum(polar_info_esti(1 : K - crc_length) ~= info_with_crc(1 : K - crc_length));
                %Caution, this is data bits error rate, regardless of CRC
                %bits.
            else
                prev_decoded(i_ebno, i_list) = 1;
            end
            
        end
    end
end
toc
end

