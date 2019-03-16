n = 10;
N = 2^n;
K = 2^(n - 1);
R = K/N;
design_snr = 2.5;%dB
%You;d better to learn more about the relationship between RM code and
%polar code. Then you can construct good polar code.
sigma = 1/sqrt(2 * R) * 10^(-design_snr/20);
max_runs = 1e5;
llr_layer_vec = get_llr_layer(N);
bit_layer_vec = get_bit_layer(N);
lambda_offset = 2.^(0 : n);
ber = zeros(N, 1);
for i_run = 1 : max_runs
    if mod(i_run, max_runs/100) == 1
        disp(['Type I monte carlo code construction running = ' num2str(i_run/max_runs*100) '%']);
    end
    dummy_info = rand(N, 1) > 0.5;
    noise = randn(N, 1);
    x = my_polar_encode(dummy_info, lambda_offset, llr_layer_vec);
    bpsk = 1 - 2 * x;
    y = bpsk + sigma * noise;
    llr = 2 * y / sigma^2;
    ber_tmp = mc_typeI_SC_decoder(llr, lambda_offset, llr_layer_vec, bit_layer_vec, dummy_info);
    ber = ber + ber_tmp;
end
[~, channel_ordered] = sort(ber);
info_bits = sort(channel_ordered(1 : K));
disp('Type I MC CC done.')
disp('Variable "info_bits" is what you want')

    
    

