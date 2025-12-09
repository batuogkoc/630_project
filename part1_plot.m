plot_Hs()

function plot_Hs()
    w = linspace(0, 2*pi, 1000);
    
    figure(1)
    hold on
    plot(w/(pi), log(abs(H_lowpass(w))), "DisplayName","Low Pass", "Color","blue")
    plot(w/(pi), log(abs(H_highpass(w))), "DisplayName","H3")
    plot(w/(pi), log(abs(H_lowpass(w).*H_highpass(-2*w))), "DisplayName","H2", "Color", "black")
    plot(w/(pi), log(abs(H_lowpass(w).*H_lowpass(2*w).*H_highpass(-4*w))), "DisplayName","H1", "Color","green")
    plot(w/(pi), log(abs(H_lowpass(w).*H_lowpass(2*w).*H_lowpass(4*w))), "DisplayName","H0", "Color","yellow")
    legend
    ylim([-10,0])
    hold off

    figure(2)
    subplot(2, 1, 1)
    hold on
    plot(w/pi, log(abs(H_total_option_1(w))), "DisplayName", "T Option 1")
    plot(w/pi, log(abs(H_total_option_2(w))), "DisplayName", "T Option 2")
    legend
    ylim([-10,0])
    hold off

    subplot(2, 1, 2)
    hold on
    plot(w/pi, angle(H_total_option_1(w)), "DisplayName", "T angle option 1")
    plot(w/pi, angle(H_total_option_2(w)), "DisplayName", "T angle option 2")
    hold off
    
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

function H = H_total_option_1(w)
    H = H_lowpass(w).*H_lowpass(2*w).*H_lowpass(4*w).*H_lowpass(4*w).*H_lowpass(2*w).*H_lowpass(1*w);
    H = H + H_lowpass(w).*H_lowpass(2*w).*H_highpass(4*w).*H_highpass(4*w).*H_lowpass(2*w).*H_lowpass(1*w).*-1;
    H = H + H_lowpass(w).*H_highpass(2*w).*H_lowpass(2*w).*H_lowpass(1*w).*-1;
    H = H + H_highpass(w).*H_highpass(1*w).*-1;
end

function H = H_total_option_2(w)
    H = H_lowpass(w).*H_lowpass(2*w).*H_lowpass(4*w).*H_lowpass(4*w).*H_lowpass(2*w).*H_lowpass(1*w);
    H = H + H_lowpass(w).*H_lowpass(2*w).*H_highpass(4*w).*H_highpass(4*w).*H_lowpass(2*w).*H_lowpass(1*w);
    H = H + H_lowpass(w).*H_highpass(2*w).*H_lowpass(2*w).*H_lowpass(1*w);
    H = H + H_highpass(w).*H_highpass(1*w);
end