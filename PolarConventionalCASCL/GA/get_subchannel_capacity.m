function cap_vec = get_subchannel_capacity(u)
cap_vec = zeros(1, length(u));
for i = 1:length(u)
    cap_vec(i) = Capacity_Binary_AWGN(u(i), sqrt(2*u(i)));
end
end