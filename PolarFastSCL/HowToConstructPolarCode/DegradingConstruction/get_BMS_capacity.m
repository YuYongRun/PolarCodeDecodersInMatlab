function IW = get_BMS_capacity(W)
%This function is employed here to verify the correctness of the program
%that is being writen
HYX = sum(W(1, :).*log2(W(1, :)));
PY = (W(1, :) + W(2, :))/2;
HY = sum(-PY.*log2(PY));
IW = HY + HYX;
end