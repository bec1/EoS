function [x1,x2,X1,X2,Yt,p1,p2 ] = CylinderOutline( img,ROI )
% get the outline of the cylinder from top image
%img: the image need to fit
%ROI: [Xmin,Ymin,Xmax,Ymax] region where there is atom

Rx = @(p,x) real(sqrt(p(2)^2- (x-p(1)).^2 ))*p(3);
% try
X=ROI(1):ROI(3);
Y=ROI(2)+1:ROI(4)-1;    
N=length(Y);
X1=zeros(1,N);X2=zeros(1,N); %X cordinator of the edge for each Y value
%imagesc(img);
%hold on

for i=1:N
    Nx=img(Y(i),X)+img(Y(i)+1,X)+img(Y(i)-1,X);
    P=OutlineFit(Nx,X,CMass1d(Nx,X),50);
    X1(i)=P(1)-abs(P(2));X2(i)=P(1)+abs(P(2));
    %plot(X1(i),Y(i),'r.','MarkerSize',20);
    %plot(X2(i),Y(i),'r.','MarkerSize',20);
end

p1=polyfit(Y,X1,1);
p2=polyfit(Y,X2,1);
Yt=1:size(img,2);
x1=polyval(p1,Yt);
x2=polyval(p2,Yt);
end

