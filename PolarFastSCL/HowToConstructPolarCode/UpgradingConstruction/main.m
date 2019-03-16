clear
snr = 2;
R = 1/2;
sigma = 1/sqrt(2 * R) * 10^(-snr/20);
n = 11;
N = 2^n;
miu = 32;
v = miu/2;
W = get_AWGN_transition_probability(sigma, v);
C_AWGN = get_AWGN_capacity(1, sigma);
IW = get_BMS_capacity(W);
disp(['AWGN with sigma = ' num2str(sigma) '. AWGN Capacity = ' num2str(C_AWGN)]);
disp(['Capacity of Upgrading cahnnel with respect to above AWGN = ' num2str(IW)]);
disp(['Capacity difference = ' num2str(IW - C_AWGN)]);
Pe = bit_channel_upgrading_procedure(W, 1 : N, miu);
