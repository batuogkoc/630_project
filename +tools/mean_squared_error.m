function res = mean_squared_error(x, x_hat)
    error = x - x_hat;
    res = sqrt(sum((abs(error).^2)./(abs(x).^2)))/length(x);
end