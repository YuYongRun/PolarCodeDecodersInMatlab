function IW = get_BMS_capacity(W)
%This function is employed here to verify the correctness of the program
%that is being writen
N = size(W, 2);
HYX = 0;
for i = 1 : N
    if W(1, i) ~= 0
        one_term = W(1, i) * log2(W(1, i));
        HYX = HYX + one_term;
    end
end
% HYX = sum(W(1, :).*log2(W(1, :)));
PY = (W(1, :) + W(2, :))/2;
HY = sum(-PY.*log2(PY));
IW = HY + HYX;
end