data = readtable("HistoricalData_1765173284756.csv"); %nasdaq last year aapl data
closing = str2double(erase(data.Close_Last, "$"));



returns = (closing(2:end) - closing(1:end-1))./closing(1:end-1);

volatility = rolling_volatility(returns, 5);
% hold on
% plot(returns)
% plot(volatility)
% hold off

Ts = -1;
A = 1;
B = 1;
C = 1;
D = 0;
sys = ss(A,[B B],C,D,Ts,'InputName',{'u' 'w'},'OutputName','y'); 

Q = 0.0001;
R = 0.01;
[kalmf,L,~,Mx,Z] = kalman(sys,Q,R);

sys.InputName = {'u','w'};
sys.OutputName = {'yt'};
vIn = sumblk('y=yt+v');

kalmf.InputName = {'u','y'};
kalmf.OutputName = 'ye';

SimModel = connect(sys,vIn,kalmf,{'u','w','v'},{'yt','ye'});

u = volatility;
t = 1:length(u);
rng(10,'twister');
w = sqrt(Q)*randn(length(t),1);
v = sqrt(R)*randn(length(t),1);
out = lsim(SimModel,[u,w,v]);
size(out)

hold on
plot(closing, "DisplayName", "actual")
plot(out(:,1) + closing(1), "DisplayName", "true")
plot(out(:,2) + closing(1), "DisplayName", "filtered")
legend
hold off
function ret = rolling_volatility(x, window_len)
    N = length(x) - window_len + 1;

    ret = zeros([N,1])
    for i = 1:N
        ret(i) = std(x(i:i+window_len-1));
    end
end