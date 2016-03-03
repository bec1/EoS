function CvTilde = GetCvTildeDerivitive( Pt,Tt ,k,q)
%using Cv=3/5 dPTilde/dTTilde to get the specific hear
%Pt,Tt is PTilde and TTilde, should be sorted before input
N=length(Pt);
CvTilde=Pt*0;

for i=1:N
    kmin=max(i-k,1);
    kmax=min(i+k,N);
    fitY=Pt(kmin:kmax);
    fitX=Tt(kmin:kmax);
    para=polyfit(fitX,fitY,q);
    para_der=polyder(para);
    CvTilde(i)=0.6*polyval(para_der,Tt(i));
end
end

