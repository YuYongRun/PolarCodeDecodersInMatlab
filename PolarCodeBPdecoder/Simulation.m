function [bler, ber] = Simulation(max_iter, max_err, max_runs, resolution, ebno_vec, N, K)
R = K/N;
n = log2(N);
num_block_err_bp = zeros(length(ebno_vec), 1);
num_bit_err_bp = zeros(length(ebno_vec), 1);
num_runs = zeros(length(ebno_vec), 1);

%Indices for enc/decoding
[M_up, M_down] = index_Matrix(N);
lambda_offset = 2.^(0 : n);
llr_layer_vec = get_llr_layer(N);

%code construction
design_snr = 2.5;
sigma_cc = 1/sqrt(2 * R) * 10^(-design_snr/20);
[channels, ~] = GA(sigma_cc, N);
[~, channel_ordered] = sort(channels, 'descend');
info_bits = sort(channel_ordered(1 : K), 'ascend');
frozen_bits = ones(N , 1);
frozen_bits(info_bits) = 0;

tic
for i_run = 1 : max_runs 
    if mod(i_run, ceil(max_runs/resolution)) == 1
        disp(['Sim iteration running = ', num2str(i_run)]);
        disp(['N = ' num2str(N) ' K = ' num2str(K) ' GA construction SNR = ' num2str(design_snr) 'dB' ' Max Iter Number = ' num2str(max_iter)])
        disp('BP BLER')
        disp(num2str([ebno_vec' num_block_err_bp./num_runs]));
        disp(' ')
    end
    u = zeros(N, 1);
    info = rand(K, 1) < 0.5 ;
    u(info_bits) = info;
    x = polar_encoder(u, lambda_offset, llr_layer_vec);
    bpsk = 1 - 2 * x;
    noise = randn(N, 1); 
    for i_ebno = 1 : length(ebno_vec) 
        if num_block_err_bp(i_ebno) > max_err
            continue;
        end
        num_runs(i_ebno) = num_runs(i_ebno) + 1;
        sigma = 1 / sqrt(2 * R) * 10^(-ebno_vec(i_ebno)/20);
        y = bpsk + sigma * noise;
        llr = 2/sigma^2 * y;
        [info_esti_bp, ~, ~, ~] = BP_Decoder_LLR(info_bits, frozen_bits, llr, max_iter, M_up, M_down);
        if any(info_esti_bp ~= info)
            num_block_err_bp(i_ebno) =  num_block_err_bp(i_ebno) + 1;
            num_bit_err_bp(i_ebno) = num_bit_err_bp(i_ebno) + sum(info ~= info_esti_bp);
        end

    end
end
toc
bler = num_block_err_bp./num_runs;
ber = num_bit_err_bp./num_runs/K;
end
