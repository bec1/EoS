function [P,P0,Pt] = GetPvsV( n,V,varargin  )
%UNTITLED2 Summary of this function goes here
%   n,V :n(V) V should already been sorted
mli=6*1.6738232*10^(-27);
N=length(n);
P=n*0;

ifsmoothing=false;

for i =1:length(varargin)
    if ischar(varargin{i})
    switch varargin{i}
        case 'Smooth'
            ifsmoothing=true;
    end
    end
end

if ifsmoothing
    ns=smooth(n);
else
    ns=n;
end

%do the integral to get P
for i=1:N-1
    intfun=ns(i:end);
    P(i)=trapz(V(i:end),intfun); %% do not use simps here, could cause some issue.
end
P(N)=0;

%Get P0
hbar=1.0545718*10^(-34);
kF=real((6*pi^2*ns).^(1/3));
EF=hbar^2*kF.^2/(2*mli);
P0=(2/5)*ns.*EF;

if ifsmoothing
    P0=smooth(P0);
end

Pt=P./P0;
end

