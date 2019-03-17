% Sim iteration running = 41001
% N = 1024 K = 512 GA construction SNR = 2.5dB Max Iter Number = 50
% BP BLER
%   1     0.70139
% 1.5     0.26234
%   2    0.051426
% 2.5    0.010047
%   3   0.0020244
% 3.5  0.00034146
% 
% Sim iteration running = 93001
% N = 2048 K = 1024 GA construction SNR = 2.5dB Max Iter Number = 50
% BP BLER
%   1     0.82114
% 1.5      0.2012
%   2    0.019847
% 2.5   0.0020258
%   3  0.00036559
% 3.5  6.4516e-05
% 
% Sim iteration running = 37001
% N = 256 K = 128 GA construction SNR = 2.5dB Max Iter Number = 50
% BP BLER
%   1         0.5
% 1.5     0.24877
%   2    0.092491
% 2.5    0.032166
%   3    0.010046
% 3.5   0.0023784
% 
% Sim iteration running = 46001
% N = 512 K = 256 GA construction SNR = 2.5dB Max Iter Number = 50
% BP BLER
%   1     0.55495
% 1.5     0.26649
%   2    0.084307
% 2.5    0.018868
%   3    0.004632
% 3.5  0.00071739

p256 = [      0.5
  0.24877
   0.092491
    0.032166
  0.010046
   0.0023784];

p512 = [    0.55495
   0.26649
  0.084307
   0.018868
   0.004632
  0.00071739];

p1024 = [    0.70139
   0.26234
   0.051426
    0.010047
   0.0020244
  0.00034146];

p2048 = [    0.82114
     0.2012
  0.019847
  0.0020258
 0.00036559
  6.4516e-05];
snr = 1 : 0.5 : 3.5;
p = semilogy(snr, [p256 p512 p1024 p2048]);
grid on
p(1).Marker = 'o';
p(2).Marker = 'd';
p(3).Marker = 'p';
p(4).Marker = 'v';

p(1).Color = 'r';
p(2).Color = 'g';
p(3).Color = 'm';

for k = 1 : 4
    p(k).MarkerSize = 8;
    p(k).LineWidth = 1.1;
end
l = legend('N = 256',...
    'N = 512',...
    'N = 1024',...
    'N = 2048');

l.Location = 'SouthWest';

xlabel('E_b/N_0 (dB)')
ylabel('BLER')
set(gca, 'fontname', 'times new roman', 'fontsize', 14)


