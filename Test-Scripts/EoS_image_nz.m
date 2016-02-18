function [ z_i, n_z ] = EoS_image_nz( imdata, varargin )
%% Information
% Extract from raw image data the n(z)
%
% Inputs are z_i and n_z
%   imdata : Cropped and corrected for background in units of Optical
%            density
%
% Outputs are k_U, P_U, U_i
%   z_i : z_i == 0 refers to the trap center
%       : must be in SI units
%   n_z : density in SI units
%
% Name value pairs include bins, trap omega, pixel, plot
% 

%% Constants
% Universal Constants
uconst.h = 6.62607004e-34;
uconst.hbar = uconst.h / (2*pi);
uconst.massLi6 = 9.988346e-27;

% Experimental Constants, CHANGE ACCORDINGLY WITH THE EXPERIMENT
econst.px = 1.44e-6;

% Other variables

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
z_i_raw = 1:size(imdata,1) * econst.px; % Number of rows in the image times pixel size in um

% Thomas Fermi fit for the center
TFfun = @(A,x) A(1)*real( (1-A(2)^2*(x-A(3))^2) ^(3/2) );


end

