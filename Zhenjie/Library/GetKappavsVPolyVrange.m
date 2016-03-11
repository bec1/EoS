function [ Kappat ] = GetKappavsVPolyVrange( n,V,Vrange,order,varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

ifsmoothing=false;

for i =1:length(varargin)
    if ischar(varargin(i))
        switch varargin{i}
            case 'Smooth'
                ifsmoothing=true;
        end
    end
end



mli=6*1.6738232*10^(-27);
N=length(n);
Kappat=n*0;

if ifsmoothing
    ns=smooth(n);
else
    ns=n;
end
% ns=smooth(n);
%Get EF
hbar=1.0545718*10^(-34);
kF=(max((6*pi^2*ns),0).^(1/3));
EF=hbar^2*kF.^2/(2*mli);

if ifsmoothing
    EF=smooth(EF);
end
% EF=smooth(EF);  

for i=1:N
    %first do some local smoothing
    %define the start and end point of smoothing
    Vmin=min(V);
    Vmax=max(V);
    V0=V(i);
    mask=abs((V-V0))<=Vrange;
    if i==200
        disp('');
    end
    if (V0-Vmin)<(Vrange/2)
        mask=abs((V-Vmin))<=Vrange;
    end
    if (Vmax-V0)<(Vrange/2)
        mask=(Vmax-V)<=Vrange;
    end
    Vf=V(mask);
    EFf=EF(mask);
%     k1=max(1,i-dk);
%     k2=min(N,i+dk);
%     Vf=V(k1:k2);EFf=EF(k1:k2);
    %Do a 2nd-ord polynomial fitting
    p=polyfit(Vf,EFf,order);
    q=polyder(p);
    Kappat(i)=-polyval(q,V(i));
end

end
