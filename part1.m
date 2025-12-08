import tools.mean_squared_error
import tools.data_generation.*;
import tools.multirate.*;

rand_data = data_1_random(1000, 16);
bandpass_data = data_2_bandpass(1000, 16);


h_0 = generate_h_coeffs();
h_1 = h_0.*(((-1).^(1:length(h_0)))*-1);

f_0 = h_0;

scramble = false;
frequency_offset = 0;

for scrambling = [true, false]
    for data_source = ["random", "bandpass"]
        for f1_type = ["h1", "-h1"]
            if data_source == "random"
                x = rand_data;
            else
                x = bandpass_data;
            end

            if f1_type == "h1"
                f_1 = h_1;
            else 
                f_1 = -h_1;
            end

            [V0, V1, V2, V3] = tools.multirate.analysis(x, h_0, h_1);
            if scramble
                [V0, V1, V2, V3] = tools.scrambling.FourChannelScrambler.scramble(V0, V1, V2, V3, 0x28, 10);
            end
            V0_hat = V0;
            V1_hat = V1;
            V2_hat = V2;
            V3_hat = V3;
            transmission_channel(V0, 0, 0);
            
            if scramble
                [V0_hat, V1_hat, V2_hat, V3_hat] = tools.scrambling.FourChannelScrambler.scramble(V0_hat, V1_hat, V2_hat, V3_hat, 0x28, 10);
            end
            x_hat = tools.multirate.synthesis(V0_hat, V1_hat, V2_hat, V3_hat, f_0, f_1);

            mse_val = mean_squared_error(x, x_hat);
            disp("Data type: " + data_source + " F1 = " + f1_type + " scrambling: " + scrambling)
            disp("mse: " + mse_val)
        end
    end
end
function x_hat = transmission_channel(x, delta_f, snr_db)
    p_signal = mean(abs(x).^2);
    x_hat = x.*exp(1j*2*pi*delta_f*(1:length(x)));

    snr_linear = 10^(snr_db/10);
    p_noise = p_signal/snr_linear;

    noise = randn(size(x)).*sqrt(p_noise);

    x_hat = x_hat+noise;
end




