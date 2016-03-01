function Tt = GetTTilde( Pt,Kt,Tf )
%This function returns the reduced temperature T/TF with input Pt and Kt as
%the reduced pressure and compressibility.
%Pt and Kt should be sorted before input
%Tf is the value for T/TF at Pt(end);

N=length(Pt);
Tt=Pt*0;
for i=1:N-1
    Pint=Pt(i:end);Kint=Kt(i:end);
    intfun=1./(Pint-1./Kint);
    F=2/5*trapz(Pint,intfun);
    Tt(i)=Tf*exp(-F);
end
Tt(N)=Tf;

end

