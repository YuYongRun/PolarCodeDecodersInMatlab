function PCi = get_PCi_vector(ELNi)
PCi = zeros(length(ELNi), 1);
for i = 1:length(ELNi)
    PCi(i) = 0.5*erfc(0.5*sqrt(ELNi(i)));
end
end