import tools.mean_squared_error
% pn1 = LFSR(10, 100, [3]);

% pn1.sequence(6)
v0 = randi([10]);
v1 = randi([10]);
v2 = randi([10]);   
v3 = randi([10]);


[v0_hat, v1_hat, v2_hat, v3_hat] = FourChannelScrambler.scramble(v0, v1, v2, v3, 0x28, 10);

[v0_rec, v1_rec, v2_rec, v3_rec] = FourChannelScrambler.scramble(v0_hat, v1_hat, v2_hat, v3_hat, 0x28, 10);

mean_squared_error(v0, v0_rec)
mean_squared_error(v1, v1_rec)
mean_squared_error(v2, v2_rec)
mean_squared_error(v3, v3_rec)
