clear
disp('adding files....')
addpath('GA/')
addpath('NodeProcess/')
addpath('NodeDecoding/')
addpath('SystematicPolarEncoders/')
addpath('PolarizaedChannelsPartialOrder/')

crc_length = 16;
[~, ~, g] = get_crc_objective(crc_length);
design_epsilon = 0.05;
n = 10;
N = 2^n;
K = N*0.5 + crc_length;
ebno_vec = 1 : 0.25 : 2.5; %row vec, you can write it like [1 1.5 2 2.5 3] 
list_vec = [1 2 4];  %row vec, you can write it like [1 4 16 32 ...]. The first element is always 1 for acceleration purpose. The ramaining elements are power of two.
max_runs = 1e9;
max_err = 100;
resolution = 1e6;%the results are shown per max_runs/resolution.
[bler, ber] = simulation(N, K, design_epsilon, max_runs, max_err, resolution,  ebno_vec, list_vec, g, crc_length);

