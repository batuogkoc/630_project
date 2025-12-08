function y = apply_system(x, h)
    y = conv(x, h, "same");
end