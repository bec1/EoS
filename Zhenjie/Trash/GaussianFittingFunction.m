function P = GaussianFittingFunction( Img )
% Does a 2d fit of a gaussian with tilt angle to the data and returns a
% vector with the optimized parameter set

% ----------------------------------------------------- %
% Parameters in seed and fixedparams                    %
% ----------------------------------------------------- %
% 1 Gaussian Amplitude      5 Horizontal Gaussian width %
% 2 Offset                  6 Vertical Gaussian width   %
% 3 Horizontal position     7 Tilt angle                %
% 4 Vertical position                                   %
% ----------------------------------------------------- %
try
% lb = [0,-8.4,0,0,eps,eps,0]; % lower bounds
% ub = [10^4,10^4,2048,2048,2048,2048,pi/4]; % upper bounds

%mesh the grid
[Ry,Rx]=size(Img);
[X,Y]=meshgrid(1:Rx,1:Ry);
%Vectorize the grid
Xv=X(:);Yv=Y(:);ImgVec=Img(:);
Xv(ImgVec==inf)=[];
Xv(isnan(ImgVec))=[];
Yv(ImgVec==inf)=[];
Yv(isnan(ImgVec))=[];
ImgVec(ImgVec==inf)=[];
ImgVec(isnan(ImgVec))=[];

%Find the center of mass of the fitted image, and use that as the initial
%center value.
Xcm=sum(Xv.*ImgVec)/sum(ImgVec);
Ycm=sum(Yv.*ImgVec)/sum(ImgVec);

%use a strip at (Xcm,Ycm) to do 1D fitting to get the initial guess for 2D
%fitting
X0=round(Xcm);
Y0=round(Ycm);
%X strip
Imgx=(Img(Y0,:));
X1d=X(Y0,:);
Px=fit1dgaussian(Imgx,X1d,X0);
%Y strip
Imgy=Img(:,X0);
Y1d=Y(:,X0);
Py=fit1dgaussian(Imgy,Y1d,Y0);
%Set the initial guess for 2d fitting
Amp=sqrt(abs(Px(1)*Py(1)));
Offset=(Px(2)+Py(2))/2;
Xc0=Xcm;
Yc0=Ycm;
Xwidth=Px(4);
Ywidth=Py(4);
theta=0;
P0=[Amp,Offset,Xc0,Yc0,Xwidth,Ywidth,theta];

Xdata={Xv,Yv};
Ydata=ImgVec;
P=fit2dgaussian(Xdata,Ydata,P0,[0,0,0,0,0,0,0]);
catch
    %send the error message and give a all zero output
    msgbox('Something went wrong in guassian fitting');
    P=[0,0,0,0,0,0,0];
end

end

function P=fit1dgaussian(Fx,x,x0)
% Does a 1d fit of a gaussian, returns a
% vector with the optimized parameter set

% ----------------------------------------------------- %
% Parameters in seed and fixedparams                    %
% ----------------------------------------------------- %
% 1 Gaussian Amplitude                                  %
% 2 Offset                                              %
% 3 center position                                     %
% 4 Gaussian width                                      %
% ----------------------------------------------------- %

%remove inf and nan
x(Fx==inf)=[];
x(isnan(Fx))=[];
Fx(Fx==inf)=[];
Fx(isnan(Fx))=[];

%initial guess
Amp=max(Fx)-min(Fx);
Offset=min(Fx);
Center=x0;
Width=60;
p0=[Amp,Offset,Center,Width];
% gaussian fit
f = @(p,xdata)p(1)*exp(-(xdata-p(3)).^2/(2*p(4)^2))+p(2); 
P = nlinfit(x,Fx,f,p0);
end
