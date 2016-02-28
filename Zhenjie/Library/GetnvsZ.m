function [ n,Z ] = GetnvsZ( img,X1,X2,Y,pixelsize,ellipticity )
%get n vs Z for top image, X1,X2 are the edge of the axicon, Y is the Z
%range we care about in hybrid trap;
Z=Y(4:end-3);
N=length(Z);
for i=1:N
    x2=X2(Z(i));
    x1=X1(Z(i));
    D=x2-x1;
    Nx=(img(Z(i),x1:x2)+img(Z(i)+1,x1:x2)+img(Z(i)-1,x1:x2))/3;
    N=sum(Nx);
    Volume=pi/4*D^2*ellipticity*pixelsize^3;
    n(i)=N/Volume;
end
end

