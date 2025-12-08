classdef LFSR < handle
    properties
        register_contents {mustBeInteger}
        xor_indices
        bit_depth {mustBeInteger}
    end
    methods 
        function obj = LFSR(bit_depth, key, xor_indices)
            obj.xor_indices = xor_indices;
            obj.bit_depth = bit_depth;
            obj.set_key(key);
        end
        function pn_bit = shift(obj)
            pn_bit = 0;
            for i = obj.xor_indices
                pn_bit = xor(pn_bit, obj.register_contents(obj.bit_depth-i));
            end
            obj.register_contents = [obj.register_contents(2:end), pn_bit];
        end
        function set_key(obj, key)
            obj.register_contents = dec2bin(key, obj.bit_depth) - '0';
        end
        function ret = sequence(obj, length)
            ret = zeros([1, length]);
            for i = 1:length
                ret(length-i+1) = obj.shift();
            end
        end
    end
end