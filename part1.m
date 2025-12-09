import tools.mean_squared_error
import tools.data_generation.*;
import tools.multirate.*;



frequency_offset = 0;
n_experiments = 1000;
results = []; 

% for scrambling = [true, false]
for scrambling = [true]
    for data_source = ["random", "bandpass"]
        for f1_type = ["h1", "-h1"]
            mse_vals = zeros(n_experiments,1);
            for iter = 1:n_experiments
                disp(iter);

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
                V0_hat = V0;
                V1_hat = V1;
                V2_hat = V2;
                V3_hat = V3;
                
                if scrambling
                    [V0_hat, V1_hat, V2_hat, V3_hat] = tools.scrambling.FourChannelScrambler.scramble(V0_hat, V1_hat, V2_hat, V3_hat, iter, 0x28);
                end
                x_hat = tools.multirate.synthesis(V0_hat, V1_hat, V2_hat, V3_hat, f_0, f_1);

                mse_val = mean_squared_error(x, x_hat);
                % disp("Data type: " + data_source + " F1 = " + f1_type + " scrambling: " + scrambling)
                % disp("mse: " + mse_val)

                mse_vals(iter) = mean_squared_error(x, x_hat);
            end
            % store average row
            results = [results; 
                struct( ...
                    'data_source',data_source,...
                    'f1_type',f1_type,...
                    'scrambling',scrambling,...
                    'avg_mse',mean(mse_vals) ...
                )];
        end
    end
end

T = struct2table(results)

disp("RESULTS:")
disp(T);



