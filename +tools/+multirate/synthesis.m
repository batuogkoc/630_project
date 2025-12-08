function x_hat = synthesis(V0, V1, V2, V3, f_0, f_1)
    u000 = V0;
    u001 = V1;
    u01 = V2;
    u1 = V3;

    u00 = tools.multirate.apply_system(upsample(u000, 2), f_0) + tools.multirate.apply_system(upsample(u001, 2), f_1);
    u00 = 2*u00;

    u0 = tools.multirate.apply_system(upsample(u00, 2), f_0)  + tools.multirate.apply_system(upsample(u01,2), f_1);
    u0 = 2*u0;

    x_hat = tools.multirate.apply_system(upsample(u0, 2), f_0)  + tools.multirate.apply_system(upsample(u1,2), f_1);
    x_hat = 2*x_hat;


end