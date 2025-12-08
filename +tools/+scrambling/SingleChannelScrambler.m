classdef SingleChannelScrambler
    methods(Static)
        function ret = scramble(x, key)
            pn1 = tools.scrambling.LFSR(26, key, [25, 3, 0]);
            pn2 = tools.scrambling.LFSR(26, key, [25, 3, 2, 1, 0]);
            len = length(x);
            ret = real(x).*(1-pn1.sequence(len).*2) + 1j*imag(x).*(1-pn2.sequence(len).*2);
        end
    end
end
