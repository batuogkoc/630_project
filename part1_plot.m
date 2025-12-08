plot_Hs()

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

