
h = tools.multirate.generate_h_coeffs()
e_0 = downsample(h, 2, 0)
e_1 = downsample(h, 2, 1)

x = randn([1,100]);
x_1 = conv(downsample(x, 2, 0), e_0, "same") + conv(downsample(x, 2, 1), e_1, "same");
x_2 = downsample(conv(x, h, "same"), 2);

x_1(1:10)
x_2(1:10)
tools.mean_squared_error(x_1, x_2)
