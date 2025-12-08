function [V0, V1, V2, V3] = analysis(x, h_0, h_1)
    v0 = downsample(tools.multirate.apply_system(x, h_0),2);
    v1 = downsample(tools.multirate.apply_system(x, h_1),2);
    V3 = v1;

    v00 = downsample(tools.multirate.apply_system(v0, h_0),2);
    v01 = downsample(tools.multirate.apply_system(v0, h_1),2);
    V2 = v01;

    v000 = downsample(tools.multirate.apply_system(v00, h_0),2);
    v001 = downsample(tools.multirate.apply_system(v00, h_1),2);
    V0 = v000;
    V1 = v001;
end