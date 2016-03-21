function [ Kappat ] = GetKappavsVPolyExp( n,V,Vstart,order,varargin )
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
EF=real(hbar^2*(6*pi^2*ns).^(2/3)/(2*mli));
hh=hbar*2*pi;

if ifsmoothing
    EF=smooth(EF);
end
% EF=smooth(EF);  

[fitresult,~]=ExpFit(V(V>Vstart), EF(V>Vstart));
a=fitresult.a;
b=fitresult.b;
ExpFun=a*exp(b*V);
fitfun=EF./ExpFun;

p=polyfit(V,fitfun,order);
Efit=polyval(p,V).*ExpFun;
q=polyder(p);
Kappat=-b*Efit-ExpFun.*polyval(q,V);

% for i=1:N
%     %first do some local smoothing
%     %define the start and end point of smoothing
%     Vmin=min(V);
%     Vmax=max(V);
%     V0=V(i);
%     mask=(V-V0)<=Vrange;
%     if (V0-Vmin)<(Vrange/2)
%         mask=(V-Vmin)<=Vrange;
%     end
%     if (Vmax-V0)<(Vrange/2)
%         mask=(Vmax-V)<=Vrange;
%     end
%     Vf=V(mask);
%     EFf=EF(mask);
% %     k1=max(1,i-dk);
% %     k2=min(N,i+dk);
% %     Vf=V(k1:k2);EFf=EF(k1:k2);
%     %Do a 2nd-ord polynomial fitting
%     p=polyfit(Vf,EFf,order);
%     q=polyder(p);
%     Kappat(i)=-polyval(q,V(i));
% end

end

