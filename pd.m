
h = [1 2 3 4 5]
% e_0 = downsample(h, 2, 0)
% e_1 = downsample(h, 2, 1)

x = [1 0 2 4 3 2 1 4 7 5]
% downsample(x, 2, 0)
% downsample(x, 2, 1)
% conv(downsample(x, 2, 0), e_0, "same")
% conv(downsample(x, 2, 1), e_1, "same")
% x_1 = conv(downsample(x, 2, 0), e_0, "same") + conv(downsample(x, 2, 1), e_1, "same");
% x_2 = downsample(conv(x, h, "same"), 2);
conv(x, h)
x_1
x_2
tools.mean_squared_error(x_1, x_2)

function y = dilated_conv(x, h, m)
    y = zeros(size(x))
    for i = 1:length(y)
        
end