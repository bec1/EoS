mli=6*1.6738232*10^(-27);
hbar=1.0545718*10^(-34);
omega=23*2*pi;
pixel=1.5*10^(-6);
Rtf=65*pixel;
mu=0.5*mli*omega^2*Rtf^2;

n=8*10^16;
kf=(6*pi^2*n)^(1/3);
Ef=hbar^2*kf^2/(2*mli);

Bfactor=mu/Ef