function [ KappaTilde, PTilde, TTilde, CV_NkB , beta_mu_vec ,Z_vec ] = IdealFermiEOS( varargin )
%IdealFermiEOS This function computes the EOS of the Ideal fermi gas
%   The input parameter is the renormalized pressure which defines the range for
%   equation of state. 
%   The actual EOS is calculated as functio of the fugacity. If the range
%   isnot sufficient increase Xstart or Xstop in the program.
%
%   The EOS @ z-> inf is P/P0=K/K0=1 


% Default parameters
defaultLogPoints = 50000;%10000;

% create input parser
p = inputParser;

addOptional(p,'LogPoints',defaultLogPoints,@isnumeric);
parse(p,varargin{:});
LogPoints = p.Results.LogPoints;

%% Generate EOS data for a large regime
beta_mu_start = -30; %-5
beta_mu_stop = 30; 
beta_mu_vec = linspace(beta_mu_start,beta_mu_stop, LogPoints);
Z_vec = exp(beta_mu_vec);

PTilde = 10*pi/(6*pi^2)^(2/3) * ...
    (-PolyLogFrac(5/2,-Z_vec)./(-PolyLogFrac(3/2,-Z_vec)).^(5/3));

KappaTilde = (6*pi^2)^(2/3)/(6*pi) * ...
    (-PolyLogFrac(1/2,-Z_vec)./(-PolyLogFrac(3/2,-Z_vec)).^(1/3));

TTilde = (4*pi)./(6*pi^2*(-PolyLogFrac(3/2,-Z_vec))).^(2/3);

CV_NkB = 15/4 * (-PolyLogFrac(5/2,-Z_vec))./(-PolyLogFrac(3/2,-Z_vec))...
    - 9/4 * (-PolyLogFrac(3/2,-Z_vec))./(-PolyLogFrac(1/2,-Z_vec));

end

