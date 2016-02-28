function [P,P0,Pt] = GetPvsVSimps( n,V )
%UNTITLED2 Summary of this function goes here
%   n,V :n(V) V should already been sorted
mli=6*1.6738232*10^(-27);
N=length(n);
P=n*0;
% ns=smooth(n);
ns=n;
%do the integral to get P
for i=1:N-1
    intfun=ns(i:end);
    P(i)=simps(V(i:end),intfun);
end
P(N)=0;

%Get P0
hbar=1.0545718*10^(-34);
kF=real((6*pi^2*ns).^(1/3));
EF=hbar^2*kF.^2/(2*mli);
P0=(2/5)*ns.*EF;
Pt=P./P0;
end


