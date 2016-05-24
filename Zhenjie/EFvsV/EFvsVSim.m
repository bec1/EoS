V=linspace(0,12,151);
mu=7;
EF=mu-V;
EF(EF<0)=0;

for i=1:length(EF)
    EF(i)=EF(i)+rand()*0.1;
end

[kappaT,~] = FiniteD( V,V*0,EF,EF*0,6);
kappaT=-kappaT;
plot(V,kappaT,'r.');
