function [ KappaTilde, PTilde, TTilde, Z_vec ] = IdealFermiEOS( PTildeMin, PTildeMax, LogPoints )
%IdealFermiEOS This function computes the EOS of the Ideal fermi gas
%   The input parameter is the renormalized pressure which defines the range for
%   equation of state. 
%   The actual EOS is calculated as functio of the fugacity. If the range
%   isnot sufficient increase Xstart or Xstop in the program.
%
%   The EOS @ z-> inf is P/P0=K/K0=1 

%% Generate EOS data for a large regime
Xstart = -5;
Xstop = 5;
X_vec = linspace(Xstart,Xstop, LogPoints);
Z_vec = exp(X_vec);

PTildeAll = 10*pi/(6*pi^2)^(2/3) * ...
    (-PolyLogFrac(5/2,-Z_vec)./(-PolyLogFrac(3/2,-Z_vec)).^(5/3));

KappaTildeAll = (6*pi^2)^(2/3)/(6*pi) * ...
    (-PolyLogFrac(1/2,-Z_vec)./(-PolyLogFrac(3/2,-Z_vec)).^(1/3));

TTildeAll = (4*pi)./(6*pi^2*(-PolyLogFrac(3/2,-Z_vec))).^(2/3);

%% Select EOS data for a certain regime defined by PTildeMax and PTildeMin
[diff1,MaxSelectIndex] = min(abs(PTildeAll - PTildeMin));
[diff2,MinSelectIndex] = min(abs(PTildeAll - PTildeMax));

PTilde = PTildeAll(MinSelectIndex:MaxSelectIndex); 
KappaTilde = KappaTildeAll(MinSelectIndex:MaxSelectIndex);
TTilde = TTildeAll(MinSelectIndex:MaxSelectIndex);
end

