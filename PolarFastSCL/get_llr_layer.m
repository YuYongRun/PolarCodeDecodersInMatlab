function layer_vec = get_llr_layer(N)
layer_vec = zeros(N , 1);
for phi = 1 : N - 1
    psi = phi;
    layer = 0;
    while(mod(psi, 2) == 0)
        psi = floor(psi/2);
        layer = layer + 1;
    end
    layer_vec(phi + 1) = layer;
end
end