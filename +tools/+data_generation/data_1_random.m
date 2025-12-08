function x = data_1_random(len, bit_depth)
    x_i = randi([-2^(bit_depth-1), 2^(bit_depth-1)-1], [1, len]);
    x_q = randi([-2^(bit_depth-1), 2^(bit_depth-1)-1], [1, len]);
    x = x_i + x_q * 1j;
end