clear;
addpath('Decoding_Index/')
addpath('GA/')
n = 9;
N = 2^n;
K = 2^(n - 1);
max_iter = 50;
max_err = 100;
max_runs = 1e8;
resolution = 1e5;
ebno_vec = 1 : 0.5 : 3.5;
[bler, ber] = Simulation(max_iter, max_err, max_runs, resolution, ebno_vec, N, K);


