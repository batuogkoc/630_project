function x = data_2_bandpass(len, bit_depth)
    n = 1:len;
    x_i = 1344 * cos(0.06*pi*n) + 864*cos(0.18*pi*n) + 8543 * cos(0.38*pi*n) - 43 * cos (0.8*pi*n);
    x_q = 1344 * sin(0.06*pi*n) + 864 * sin(0.18*pi*n) + 8543 * sin(0.38*pi*n) - 43 * sin (0.8*pi*n);
    x = x_i + x_q * 1j;
end