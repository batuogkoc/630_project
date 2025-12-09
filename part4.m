data = readtable("HistoricalData_1765173284756.csv"); 

closing = str2double(erase(data.Close_Last, "$"));


returns = (closing(2:end) - closing(1:end-1)) ./ closing(1:end-1);
vol_window = 10;
volatility = rolling_volatility(returns, vol_window);

dt = 1; 
F = [1, 1;
     0, 1];

H = [1, 0];

Q = [0.0001, 0; 
     0,      0.0001]; 

R = 0.05;     

N = length(closing);
x_est = zeros(2, N);      
P_cov = eye(2) * 1;       
x_est(:, 1) = [closing(1); 0]; 

for t = 2:N
    x_pred = F * x_est(:, t-1);
    P_pred = F * P_cov * F' + Q;
    
    z = closing(t);            
    y_residual = z - H * x_pred; 
    
    S = H * P_pred * H' + R;
    K = P_pred * H' / S;      
    
    x_est(:, t) = x_pred + K * y_residual;
    P_cov = (eye(2) - K * H) * P_pred;
end

hold on
plot(closing, 'DisplayName', 'Actual Price Data');
plot(x_est(1, :), 'DisplayName', 'Kalman Estimate (Price)');

legend;
grid on;
hold off

disp(tools.mean_squared_error(closing.', x_est(1, :)))


function ret = rolling_volatility(x, window_len)
    N = length(x) - window_len + 1;
    ret = zeros(N,1); 
    for i = 1:N
        ret(i) = std(x(i:i+window_len-1));
    end
end