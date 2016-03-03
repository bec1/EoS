function [ KappaTilde, PTilde, TTilde, Z_vec ] = ...
    VirialUnitarity(  PTildeMin, PTildeMax, LogPoints , order )
%VirialUnitarity This function computes the virial expansion of the EOS of 
% the unitary fermi gas. (copressibility vs. pressure vs. temperature)
% 
% Input parameters:
% Renormalized pressure (PTildeMin to PTildeMax) defines the range for
% equation of state.
% LogPoints specifies the amount of data points on a log scale
% Order selects the order of the virial expansion.

% Coefficient for the virial expansion
b2ref = 3*sqrt(2)/8;
b3ref = -0.29095295; % Phys. Rev. Lett. 102, 160401 (2009)
b4ref = 0.065; % Science 335, 563 (2012)

if order==1
    b2=0;
    b3=0;
    b4=0;
elseif order==2
    b2=b2ref;
    b3=0;
    b4=0;
elseif order==3
    b2=b2ref;
    b3=b3ref;
    b4=0;
elseif order==4
    b2=b2ref;
    b3=b3ref;
    b4=b4ref;
end

%% Generate EOS data for a large regime
Xstart = -5;
Xstop = 5;
X_vec = linspace(Xstart,Xstop, LogPoints);
Z_vec = exp(X_vec);

PTildeAll = 10*pi/(6*pi^2)^(2/3).* (Z_vec + b2 .* Z_vec.^2 + b3 .* Z_vec.^3 + b4 * Z_vec.^4)...
    ./ (Z_vec + 2*b2 .* Z_vec.^2 + 3*b3 .* Z_vec.^3 + 4*b4 * Z_vec.^4).^(5/3);

KappaTildeAll = (6*pi^2)^(2/3)/(6*pi) .* (Z_vec + 4*b2 .* Z_vec.^2 + 9*b3 .* Z_vec.^3 + 16*b4 * Z_vec.^4)...
    ./(Z_vec + 2*b2 .* Z_vec.^2 + 3*b3 .* Z_vec.^3 + 4*b4 * Z_vec.^4).^(1/3);

TTildeAll = 4*pi ./ (6* pi^2 * (Z_vec + 2*b2 .* Z_vec.^2 + 3*b3 .* Z_vec.^3 + 4*b4 * Z_vec.^4)).^(2/3);

%% Select EOS data for a certain regime defined by PTildeMax and PTildeMin
[diff1,MaxSelectIndex] = min(abs(PTildeAll - PTildeMin));
[diff2,MinSelectIndex] = min(abs(PTildeAll - PTildeMax));

PTilde = PTildeAll(MinSelectIndex:MaxSelectIndex); 
KappaTilde = KappaTildeAll(MinSelectIndex:MaxSelectIndex);
TTilde = TTildeAll(MinSelectIndex:MaxSelectIndex);

end

