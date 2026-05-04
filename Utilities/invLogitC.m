function x = invLogitC(C, alpha)

x = 1 ./ (1 + exp(-C./alpha));

end