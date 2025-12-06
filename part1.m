rand_data = data_1_random(1000, 16);
bandpass_data = data_2_band_pass(1000, 16);

% plot_Hs()
% x = cos(linspace(0, 150*2*pi, 1000)) + cos(linspace(0, 350*2*pi, 1000));
x = bandpass_data;
x = rand_data;
h_0 = generate_h_coeffs();
h_1 = h_0.*(((-1).^(1:length(h_0)))*-1);

f_0 = h_0;
f_1 = -h_1;


sanity_check(x, h_0, h_1, f_0, f_1)
% plot_Hs()

function sanity_check(x, h0, h1, f0, f1)
    hold on
    legend
    N = length(x)
    
    v0 = downsample(apply_system(x, h0), 2);


%     v00 = downsample(apply_system(v0, h0), 2);
%     v01 = downsample(apply_system(v0, h1), 2);

    v1 = downsample(apply_system(x, h1), 2);
    
    
%     hold on
% %     plot(abs(fft(x, N)), DisplayName="x")
%     plot(abs(fft(apply_system(x, h1), N)), DisplayName="x high")
%     plot(abs(fft(apply_system(upsample(downsample(apply_system(x, h1), 2), 2), -h1), N)), DisplayName="x low decimated")
%     legend
%     hold off

%     u0 = (apply_system(upsample(v00, 2), f0) + apply_system(upsample(v01, 2), f1))*2;
    x_hat = (apply_system(upsample(v0, 2), f0) + apply_system(upsample(v1, 2), f1))*2;
    
    plot(log(abs(fft(x, N))), DisplayName="x low")
    plot(log(abs(fft(x_hat, N))), DisplayName="x high")


    hold off
end

function [V0, V1, V2, V3] = analysis(x, h_0, h_1)
    v0 = downsample(apply_system(x, h_0),2);
    v1 = downsample(apply_system(x, h_1),2);
    V3 = v1;

    v00 = downsample(apply_system(v0, h_0),2);
    v01 = downsample(apply_system(v0, h_1),2);
    V2 = v01;

    v000 = downsample(apply_system(v00, h_0),2);
    v001 = downsample(apply_system(v00, h_1),2);
    V0 = v000;
    V1 = v001;
end


function x_hat = synthesis(V0, V1, V2, V3, f_0, f_1)
    u000 = V0;
    u001 = V1;
    u01 = V2;
    u1 = V3;

    u00 = apply_system(upsample(u000, 2), f_0) + apply_system(upsample(u001, 2), f_1);

    u0 = apply_system(upsample(u00, 2), f_0)  + apply_system(upsample(u01,2), f_1);

    x_hat = apply_system(upsample(u0, 2), f_0)  + apply_system(upsample(u1,2), f_1);


end

function y = apply_system(x, h)
    y = conv(x, h, "same");
end
% function y = decimate(x, ratio)
%     y = x(:, 1:ratio:end);
% end
% 
% function y = expand(x, ratio)
%     y = zeros(1,(length(x)-1)*ratio+1);
%     y(1:ratio:end) = x;
% end

function plot_Hs()
    w = linspace(0, 2*pi, 1000);
    hold on
    plot(w/(pi), log(abs(H_lowpass(w))), "DisplayName","Low Pass", "Color","blue")
    plot(w/(pi), log(abs(H_highpass(w))), "DisplayName","H3")
    plot(w/(pi), log(abs(H_lowpass(w).*H_highpass(-2*w))), "DisplayName","H2", "Color", "black")
    plot(w/(pi), log(abs(H_lowpass(w).*H_lowpass(2*w).*H_highpass(-4*w))), "DisplayName","H1", "Color","green")
    plot(w/(pi), log(abs(H_lowpass(w).*H_lowpass(2*w).*H_lowpass(4*w))), "DisplayName","H0", "Color","yellow")
    legend
    ylim([-10,0])
    hold off
end


function x = data_1_random(len, bit_depth)
    x_i = randi([-2^(bit_depth-1), 2^(bit_depth-1)-1], [1, len]);
    x_q = randi([-2^(bit_depth-1), 2^(bit_depth-1)-1], [1, len]);
    x = x_i + x_q * 1j;
end

function x = data_2_band_pass(len, bit_depth)
    n = 1:len;
    x_i = 1344 * cos(0.06*pi*n) + 864*cos(0.18*pi*n) + 8543 * cos(0.38*pi*n) - 43 * cos (0.8*pi*n);
    x_q = 1344 * sin(0.06*pi*n) + 864 * sin(0.18*pi*n) + 8543 * sin(0.38*pi*n) - 43 * sin (0.8*pi*n);
    x = x_i + x_q * 1j;
end

function res = mse(x, x_hat)
    error = x - x_hat;
    res = sqrt(sum((abs(error).^2)./(abs(x).^2)))/length(x);
end


function h = generate_h_coeffs()
    h=[-1 0 3 0 -8 0 21 0 -45 0 91 0 -191 0 643 1024 643 0 -191 0 91 0 -45 0 21 0 -8 0 3 0 -1];

    h = h/2050;
end

function H = H_lowpass(w)
    H = 2 * exp(-1j*15*w) .* (...
    -cos(15*w) + 3*cos(13*w) - 8*cos(11*w) + 21*cos(9*w) ...
    - 45*cos(7*w) + 91*cos(5*w) - 191*cos(3*w) + 643*cos(w) + 512);
    H = H/2050;
end

function H = H_highpass(w)
    H =  2 * exp(-1j*15*w) .* (...
    -cos(15*w) + 3*cos(13*w) - 8*cos(11*w) + 21*cos(9*w) ...
    - 45*cos(7*w) + 91*cos(5*w) - 191*cos(3*w) + 643*cos(w) - 512);

    H = H/2050;
end

