function W = get_AWGN_transition_probability(sigma, v)
alpha = get_Clambda_zero_points(v);
y = get_y_interval(sigma, alpha);
W = upgrading_transform_AWGN_to_DMC(y, alpha, sigma, v);
end
