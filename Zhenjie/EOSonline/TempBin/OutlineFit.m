function P=OutlineFit(Nx,x,x0,R0)
fitfun = @(p,x) real(sqrt(p(2)^2- (x-p(1)).^2 ))*p(3);
P=nlinfit(x,Nx,fitfun,[x0,R0,max(Nx)]);
end