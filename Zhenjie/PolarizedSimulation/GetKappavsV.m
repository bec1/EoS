function [ Kappat ] = GetKappavsV( n,V )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
mli=6*1.6738232*10^(-27);
N=length(n);
Kappat=n*0;
% ns=smooth(n);
ns=n;
%Get EF
hbar=1.0545718*10^(-34);
kF=real((6*pi^2*ns).^(1/3));
EF=hbar^2*kF.^2/(2*mli);
% EF=smooth(EF);

for i=1:N
    %first do some local smoothing
    %define the start and end point of smoothing
    k1=max(1,i-20);
    k2=min(N,i+20);
    Vf=V(k1:k2);EFf=EF(k1:k2);
    %Do a 2nd-ord polynomial fitting
    p=polyfit(Vf,EFf,8);
    q=polyder(p);
    Kappat(i)=-polyval(q,V(i));
end

end

