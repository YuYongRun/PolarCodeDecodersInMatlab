function z = Clambda(lambda)
z = 1 - lambda./(1 + lambda).*log2(1 + 1./lambda) - 1./(1 + lambda).*log2(1 + lambda);
end