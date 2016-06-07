function [P,P0,Pt] = GetPvsZ( n,z,omega,pixelsize )
%use P=\int_U^{\inf} dU n(U) to get the pressure of cloud at z, and Pt=P/P0
%n: n(z)
%z: z position (in pixel), the center of cloud is z=0
%omega: trapping frequency
mli=6*1.6738232*10^(-27);

N=length(n);
P=n*0;
dUdz=mli*omega^2*z*pixelsize;

for i=1:N-1
    intfun=n(i:end).*dUdz(i:end);
    P(i)=trapz(z(i:end)*pixelsize,intfun);
end

hbar=1.0545718*10^(-34);
n(n<0)=0;
kF=real((6*pi^2*n).^(1/3));

EF=hbar^2*kF.^2/(2*mli);
P0=(2/5)*n.*EF;

Pt=P./P0;
end

