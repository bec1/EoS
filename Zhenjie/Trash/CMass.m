function [ Xc,Yc ] = CMass( image )
%get the center of mass of the image
[m,n]=size(image);
[X,Y]=meshgrid(1:n,1:m);
image=image(:);X=X(:);Y=Y(:);
X(isnan(image))=[];
Y(isnan(image))=[];
image(isnan(image))=[];
X(image==inf)=[];
Y(image==inf)=[];
image(image==inf)=[];
X(image==-inf)=[];
Y(image==-inf)=[];
image(image==-inf)=[];

Xc=sum(X.*image)/sum(image);
Yc=sum(Y.*image)/sum(image);
end

