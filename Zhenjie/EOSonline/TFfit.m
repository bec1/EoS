function P = TFfit( n,Z,R0)
%TFFIT Summary of this function goes here
%p(1):mu, chemical potential
%p(2):Z0, the center of the trap
%P(3):RF, TF radius
TF = @(P,z) real( P(1)^(3/2)* (1-(z-P(2)).^2/(P(3)).^2).^(3/2)); 
[nmax,m]=max(n);
Z0=Z(m);
mu0=nmax^(2/3);
P=nlinfit(Z,n,TF,[mu0,Z0,R0]);
end

