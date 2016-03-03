function [ KappaTilde, PTilde, TTilde, CI_NkF, Z_vec ] = ...
    VirialUnitarity( varargin )
%VirialUnitarity This function computes the virial expansion of the EOS of 
% the unitary fermi gas. (copressibility, pressure, temperature, contact)
% 
% Optional name value input parameters:
% "LogPoints: specifies the amount of data points on a log scale. If nothing
% is given as an input the default value is 10000.
% "Order" selects the order of the virial expansion (default value 3).
% The 'ContactOrder' can be selected between 2 and 3 (default
% value 3).

% Default parameters
defaultLogPoints = 10000;
defaultOrder = 3;
defaultContactOrder = 3;

% create input parser
p = inputParser;

addParameter(p,'LogPoints',defaultLogPoints,@isnumeric);
addParameter(p,'Order',defaultOrder,@isnumeric)
addParameter(p,'ContactOrder',defaultContactOrder,@isnumeric)

parse(p,varargin{:});

LogPoints = p.Results.LogPoints;
order = p.Results.Order;
ContactOrder = p.Results.ContactOrder;

% Coefficient for the virial expansion
b2ref = 3*sqrt(2)/8;
b3ref = -0.29095295; % Phys. Rev. Lett. 102, 160401 (2009)
b4ref = 0.065; % Science 335, 563 (2012)

% Coefficient for the contact virial expansion
c2ref = 1/pi;
c3ref = -0.141; 

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

% contact coefficients
if ContactOrder==2
    c2=c2ref;
    c3=0;
elseif ContactOrder==3
    c2=c2ref;
    c3=c3ref;
end

%% Generate EOS data
Xstart = -6;
Xstop = -0.3;
X_vec = linspace(Xstart,Xstop, LogPoints);
Z_vec = exp(X_vec);

PTilde = 10*pi/(6*pi^2)^(2/3).* (Z_vec + b2 .* Z_vec.^2 + b3 .* Z_vec.^3 + b4 * Z_vec.^4)...
    ./ (Z_vec + 2*b2 .* Z_vec.^2 + 3*b3 .* Z_vec.^3 + 4*b4 * Z_vec.^4).^(5/3);

KappaTilde = (6*pi^2)^(2/3)/(6*pi) .* (Z_vec + 4*b2 .* Z_vec.^2 + 9*b3 .* Z_vec.^3 + 16*b4 * Z_vec.^4)...
    ./(Z_vec + 2*b2 .* Z_vec.^2 + 3*b3 .* Z_vec.^3 + 4*b4 * Z_vec.^4).^(1/3);

TTilde = 4*pi ./ (6* pi^2 * (Z_vec + 2*b2 .* Z_vec.^2 + 3*b3 .* Z_vec.^3 + 4*b4 * Z_vec.^4)).^(2/3);

CI_NkF = 48 * pi^4 * (c2 * Z_vec.^2+ c3 * Z_vec.^3)...
    ./ (6*pi^2*(Z_vec + 2*b2 .* Z_vec.^2 + 3*b3 .* Z_vec.^3 + 4*b4 * Z_vec.^4)).^(4/3);


end

