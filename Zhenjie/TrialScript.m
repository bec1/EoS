%try n vs V

omega=23*2*pi;pixelsize=1.44e-6;
n=smooth(n);
Z=z*pixelsize;
mli=6*1.6738232*10^(-27);
N=length(n);
Kappa=n*0;
Kappa0=Kappa;
Kappat=Kappa;
V=1/2*mli*omega^2*Z.^2;
[Vs,I]=sort(V);
ns=n(I);
ns=smooth(ns)';
dndVs=ns*0;
dndV=ns*0;
scatter(z,n)
scatter(Vs,ns)


for i=1:N
    %first do some local smoothing
    %define the start and end point of smoothing
    k1=max(1,i-40);
    k2=min(N,i+40);
    Vf=Vs(k1:k2);nf=ns(k1:k2);
    %Do a 2nd-ord polynomial fitting
    p=polyfit(Vf,nf,2);
    q=polyder(p);
    dndVs(i)=polyval(q,Vs(i));
end

scatter(Vs,dndVs);
% 
% % try n vs z

% Z=z*pixelsize;
% mli=6*1.6738232*10^(-27);
% N=length(n);
% Kappa=n*0;
% Kappa0=Kappa;
% Kappat=Kappa;
% dVdz=mli*omega^2*Z;
% 
% for i=1:N
%     %first do some local smoothing
%     %define the start and end point of smoothing
%     k1=max(1,i-20);
%     k2=min(N,i+20);
%     Zf=Z(k1:k2);nf=n(k1:k2);
%     %Do a 2nd-ord polynomial fitting
%     p=polyfit(Zf,nf,6);
%     q=polyder(p);
%     dndV(i)=polyval(q,Z(i))/dVdz(i);
% end
% 
% scatter(Z,dndV)



%try get P(n) by n(V)
Z=z*pixelsize;
mli=6*1.6738232*10^(-27);
N=length(n);
P=n*0;
V=1/2*mli*omega^2*Z.^2;
[Vs,I]=sort(V);
ns=n(I);
ns=smooth(ns)';
for i=1:N-1
    intfun=ns(i:end);
    P(i)=trapz(Vs(i:end),intfun);
end
P(N)=0;
scatter(Vs,P)

hbar=1.0545718*10^(-34);
kF=real((6*pi^2*ns).^(1/3));
EF=hbar^2*kF.^2/(2*mli);
P0=(2/5)*ns.*EF;

P0=smooth(P0);

Pt=P./P0;
scatter(Vs,Pt)
ylim([0,4])

omega=23*2*pi;pixelsize=1.44e-6;
Z=z*pixelsize;
V=1/2*mli*omega^2*Z.^2;
[Vs,I]=sort(V);
ns=n(I);
[P,P0,Pt] = GetPvsV( ns,Vs' );
scatter(Vs,Pt)
ylim([0,4])
Kt=GetKappavsV( ns,Vs );
scatter(z,n)
scatter(Vs,Kt)
scatter(Pt,Kt)
xlim([0,4])
ylim([0,4])