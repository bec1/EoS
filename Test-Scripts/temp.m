U_i;
n_U;
EF_U;

k1 = - diff(EF_U) / diff(U_i);

f = spline(U_i,EF_U);
fd = fnder(f);
% fnplt(f);
fnplt(fd)