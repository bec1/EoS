function [ n,Z ] = GetnvsZ( img,X1,X2,Y,pixelsize,ellipticity,varargin )
%get n vs Z for top image, X1,X2 are the edge of the axicon, Y is the Z
%range we care about in hybrid trap;
Nmethod=0;
Xl=6;

for i =1:length(varargin)
    if ischar(varargin{i})
    switch varargin{i}
        case 'Nmethod'
            Nmethod=varargin{i+1};
    end
    end
end


Z=Y(4:end-3);
N=length(Z);
n=Z*0;

if Nmethod==0
for i=1:N
    x2=X2(Z(i));
    x1=X1(Z(i));
    D=x2-x1;
    Nx=(img(Z(i),round(x1):round(x2))+img(Z(i)+1,round(x1):round(x2))+img(Z(i)-1,round(x1):round(x2)))/3;
    N=sum(Nx);
    Volume=pi/4*D^2*ellipticity*pixelsize^3;
    n(i)=N/Volume;
end
end


if Nmethod==1
for i=1:N
    x2=X2(Z(i));
    x1=X1(Z(i));
    x0=(x2+x1)/2;
    D=x2-x1;
    R=D/2;
    X=round(x0)-Xl:round(x0)+Xl;
    Nx=(img(Z(i),min(X):max(X))+img(Z(i)+1,min(X):max(X))+img(Z(i)-1,min(X):max(X)))/3;
    N=sum(Nx);
    DX=X-x0;
    L=2*sqrt(R^2-DX.^2);
    Volume=sum(L)*pixelsize^3;
    n(i)=N/Volume;
end
end

end

