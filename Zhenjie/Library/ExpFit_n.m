function [P,nexp,Vexp,nfinal,Vfinal] = ExpFit_n( n,V,Pcutoff )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant

fitfun=@(p,x) p(1)*exp(-p(2)*x)+p(3);
nmax=max(n);
portion=n/nmax;

nfit=n(portion<Pcutoff)/nmax;
Vfit=V(portion<Pcutoff)/hh;

p0=[1,1/3000,0];
P1=nlinfit(Vfit,nfit,fitfun,p0);
P=[P1(1)*nmax,P1(2)/hh,P1(3)*nmax];
Vexp=V;
nexp=fitfun(P,Vexp);

% scatter(V,n);
% hold on
% plot(Vexp,nexp);
% hold off

nfinal=n;
Vfinal=V;
nfinal(portion<Pcutoff)=nexp(portion<Pcutoff);
Vfinal(portion<Pcutoff)=Vexp(portion<Pcutoff);
nfinal=nfinal-P(3);
end

