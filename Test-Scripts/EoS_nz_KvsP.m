function [ k_U, P_U, U_i ] = EoS_nz_KvsP( z_i, n_z, varargin )
%% Information
% Extract from n(z) the kappa(U) and P(U)
%
% Inputs are z_i and n_z
%   z_i : z_i == 0 refers to the trap center
%       : must be in SI units
%   n_z : density in SI units
%
% Outputs are k_U, P_U, U_i
%   U_i : the binned potential values
%   P_U : P/P0 in SI units
%   k_U : kappa/kappa0 in SI units
%
% Name value pairs include bins, trap omega, pixel, plot
% 

%% Constants
% Universal Constants
uconst.h = 6.62607004e-34;
uconst.hbar = uconst.h / (2*pi);
uconst.massLi6 = 9.988346e-27;

% Experimental Constants, CHANGE ACCORDINGLY WITH THE EXPERIMENT
econst.trapw = 2*pi*23.9;
econst.px = 1.44e-6;

% Other variables
total_bins = 40;
create_plot = 1;

% Process inputs
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'bins', total_bins = varargin{i+1};
        case 'trap omega', econst.trapw = varargin{i+1};
        case 'pixel', econst.px = varargin{i+1};
        case 'plot', create_plot = varargin{i+1};
    end
end

%% Procedure
% Create potential U(z)
U_z = 0.5*uconst.massLi6*econst.trapw^2*z_i.^2;

% Calculate n_U and EF_U and U_i by binning
U_i = linspace(0,max(U_z),total_bins+1)'; % Note that size now is total_bins+1. This is neccesary for binning and will be removed later.
n_U = zeros(total_bins,1);
whichbin = discretize(U_z,U_i);
for i=1:total_bins
    binMembers = n_z(whichbin == i);
    n_U(i) = mean(binMembers);
end
U_i = U_i(1:end-1); % Fixing the extra
EF_U = uconst.hbar^2 / (2*uconst.massLi6) * (6*pi^2*n_U).^(2/3);

% Calculate P/P0 and k/k0
P_U = zeros(total_bins-1,1);
k_U = zeros(total_bins-1,1);

for i = 1:total_bins-1, P_U(i) = trapz(U_i(i:end),n_U(i:end)); end
P_U = P_U ./ (2/5*n_U(1:end-1).*EF_U(1:end-1)) ;

k_U = - diff(EF_U) / (U_i(2)-U_i(1)); 

%% Figure
if create_plot
    figure;
    subplot(2,2,1);
    grid on; title('Density and Potential vs z');  xlim([z_i(1),z_i(end)]*1e6); xlabel('z (\mum)');
    yyaxis left
    plot(z_i*1e6,n_z);  ylabel('n (m^{-3})');
    yyaxis right
    plot(z_i*1e6,U_z/(uconst.h*1e3)); ylabel('U (kHz)');

    subplot(2,2,2);
    grid on;  title('Density and Fermi energy vs U'); xlabel('U (kHz)'); xlim([U_i(1),U_i(end)]/(uconst.h*1e3)); 
    yyaxis left
    plot(U_i/(uconst.h*1e3),n_U);  ylabel('n (m^{-3})');
    yyaxis right
    plot(U_i/(uconst.h*1e3),EF_U/(uconst.h*1e3));  ylabel('E_F (kHz)');

    subplot(2,2,3);
    grid on;  title('Compressibility and Pressure vs U');  xlabel('U (kHz)'); xlim([U_i(1),U_i(end)]/(uconst.h*1e3));
    yyaxis left
    plot(U_i(1:end-1)/(uconst.h*1e3),k_U); ylim([0 5]);  ylabel('\kappa / \kappa_0');
    yyaxis right
    plot(U_i(1:end-1)/(uconst.h*1e3),P_U); ylim([0 1]); ylabel('P / P_0');

    subplot(2,2,4);
    plot(P_U,k_U,'r.'); xlim([0 1]); ylim([0 4]);
    title('\kappa / \kappa_0 vs P / P_0'); xlabel('P / P_0'); ylabel('\kappa / \kappa_0'); grid on;
end


end

