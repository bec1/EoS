function [Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel] = GenerateEoS( n,Z, mli,omega,Cutoff,k1,k2,points,order )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Ptf=TFfit(n,Z,50e-6);
Ztf=Ptf(3);
Z0=Ptf(2);
Z_centered=Z-Z0;
Zcutoff=Ztf*Cutoff;
% Cut the tail that is too far away
n_cut=n(abs(Z_centered)<Zcutoff);
Z_cut=Z(abs(Z_centered)<Zcutoff);
%generate the V
V=0.5*mli*omega^2*Z_cut.^2;
[Vsort,B]=sort(V);
nsort=n_cut(B);
Zsort=Z_cut(B);
%get PTilde
[~,~,Pt] = GetPvsV( nsort,Vsort );
%get kappaTilde
Kt = GetKappavsVPoly( nsort,Vsort,points,order );
%select the range we want to have data;
Zmax=Ztf*k2;
Zmin=Ztf*k1;

Ptsel=Pt;
Ktsel=Kt;
Zsel=Zsort;

Ptsel(abs(Zsel)>Zmax)=[];
Ktsel(abs(Zsel)>Zmax)=[];
Zsel(abs(Zsel)>Zmax)=[];

Ptsel(abs(Zsel)<Zmin)=[];
Ktsel(abs(Zsel)<Zmin)=[];
Zsel(abs(Zsel)<Zmin)=[];

end

