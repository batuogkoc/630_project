classdef FourChannelScrambler
    methods(Static)
        function [v0_hat, v1_hat, v2_hat, v3_hat] = scramble(v0, v1, v2, v3, frame_number, group_id)
            
            key_0 = bitshift(frame_number, 10) + group_id;
            key_1 = bitshift(frame_number, 11) + group_id*3;
            key_2 = bitshift(frame_number, 12) + group_id*5;
            key_3 = bitshift(frame_number, 13) + group_id*7;

            v0_hat = tools.scrambling.SingleChannelScrambler.scramble(v0, key_0);
            v1_hat = tools.scrambling.SingleChannelScrambler.scramble(v1, key_1);
            v2_hat = tools.scrambling.SingleChannelScrambler.scramble(v2, key_2);
            v3_hat = tools.scrambling.SingleChannelScrambler.scramble(v3, key_3);

        end
    end
end