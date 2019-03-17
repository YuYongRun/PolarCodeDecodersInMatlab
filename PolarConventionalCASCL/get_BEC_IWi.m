function IWi = get_BEC_IWi(N, C)
IWi = zeros(1, N);
IWi(1) = C;
I_ = zeros(1, N);
m = 1;
while(m <= N/2)
    for k = 1 : m
        I_(k) = IWi(k) * IWi(k);
        I_(k + m) = 2 * IWi(k) - IWi(k) * IWi(k);
    end
    IWi = I_;
    m = m * 2;
end
IWi = bitrevorder(IWi);
