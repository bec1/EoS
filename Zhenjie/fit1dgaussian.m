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