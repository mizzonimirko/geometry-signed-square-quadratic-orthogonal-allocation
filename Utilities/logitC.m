function C = logitC(x, alpha)

x = min(max(x,1e-6),1-1e-6);

C = alpha .* log(x ./ (1-x));

end