%rewrite Gauss Approximation for PolarCode construction
%more accurate and easier to read and much quicker
%GA for BPSK-AWGN   BPSK = [1 -1] 
%such that y = bpsk + noise, llr = 2y/sigma^2 subjects to N(2/sigma^2, 4/sigma^2) when zero
%code word is transmitted
EbN0 = 1;
R = 0.5;
sigma = sqrt(1/2/R)*10^(-EbN0/20);
n = 10;
N = 2^n;
tic
u = GA(sigma, N);%u is the mean value vector for subchannels after the wohle polarization process
toc
% cap_vec = get_subchannel_capacity(u);
% ber_vec = get_PCi_vector(u);
% u
% cap_vec
% ber_vec
