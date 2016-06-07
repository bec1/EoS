function [Out,Outerr] = FiniteD( x,xstd,y,ystd,SD,varargin )
%FINITED Summary of this function goes here
%   Detailed explanation goes here
N=length(x);
Out=y*0;
Outerr=Out;
for i=1:N
    k1=max(1,i-SD);
    k2=min(N,i+SD);
    %Out(i)=(y(k2)-y(k1))/(x(k2)-x(k1));
    if k2-k1>1
        k0=round((k1+k2)/2);
        X=[x(k1),x(k0),x(k2)];
        Y=[y(k1),y(k0),y(k2)];
        p=polyfit(X,Y,2);
        dp=polyder(p);
        Out(i)=polyval(dp,x(i));
    else
        Out(i)=(y(k2)-y(k1))/(x(k2)-x(k1));
    end
    %Outerr(i)=sqrt(((ystd(k2)+ystd(k1))/(y(k2)-y(k1)))^2+((xstd(k2)+xstd(k1))/(x(k2)-x(k1)))^2)*Out(i);
    deltay=sqrt(ystd(k2)^2+ystd(k1)^2);
    deltax=sqrt(xstd(k2)^2+xstd(k1)^2);
    Outerr(i)=sqrt((deltay/(x(k2)-x(k1)))^2+(deltax*(y(k2)-y(k1))/(x(k2)-x(k1))^2)^2);
end

end

