import tools.mean_squared_error
import tools.data_generation.*;
import tools.multirate.*;


scrambling = true;
frequency_offset = 156.25;
n_experiments = 100;
f1_type = "-h1";
data_source = "random";
results = []; 

for snr_db = 1:20
    disp(snr_db)
    mse_vals = zeros(n_experiments,1);
    for iter = 1:n_experiments
        %% Input data
        if data_source == "random"
            x = data_1_random(1024, 16);
        else
            x = data_2_bandpass(1024, 16);
        end
        
        h_0 = generate_h_coeffs();
        h_1 = h_0.*(((-1).^(1:length(h_0)))*-1);
        f_0 = h_0;
        if f1_type == "h1"
            f_1 = h_1;
        else 
            f_1 = -h_1;
        end

        [V0, V1, V2, V3] = tools.multirate.analysis(x, h_0, h_1);
        if scrambling
            [V0, V1, V2, V3] = tools.scrambling.FourChannelScrambler.scramble(V0, V1, V2, V3, iter, 0x28);
        end
        V0_hat = transmission_channel(V0, frequency_offset, snr_db);
        V1_hat = transmission_channel(V1, frequency_offset, snr_db);;
        V2_hat = transmission_channel(V2, frequency_offset, snr_db);;
        V3_hat = transmission_channel(V3, frequency_offset, snr_db);;
        
        if scrambling
            [V0_hat, V1_hat, V2_hat, V3_hat] = tools.scrambling.FourChannelScrambler.scramble(V0_hat, V1_hat, V2_hat, V3_hat, iter, 0x28);
        end

        x_hat = tools.multirate.synthesis(V0_hat, V1_hat, V2_hat, V3_hat, f_0, f_1);

        mse_val = mean_squared_error(x, x_hat);

        mse_vals(iter) = mean_squared_error(x, x_hat);
    end
    % store average row
    results = [results; 
        struct( ...
            'snr_db',snr_db,...
            'avg_mse',mean(mse_vals) ...
        )];
end

T = struct2table(results)

disp("RESULTS:")
disp(T);

plot(T.snr_db, T.avg_mse)

function x_hat = transmission_channel(x, delta_f, snr_db)
    p_signal = mean(abs(x).^2);
    x_hat = x.*exp(1j*2*pi*delta_f*(1:length(x)));

    snr_linear = 10^(snr_db/10);
    p_noise = p_signal/snr_linear;

    noise = randn(size(x)).*sqrt(p_noise);

    x_hat = x_hat+noise;
end




