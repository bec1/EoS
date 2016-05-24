function g = PolyLogFrac(n,z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Fractinal PolyLogarithms: PolyLog(n,z)
%
%               Coded by Manuel Diaz, NTU, 2014.12.23.
%                   Copyright (c) 2014, Manuel Diaz.
%                           All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We extend matlab definition of polylog to enable the computation of
% fractional values of 'n' by using numerical approximations of the
% Fermi-Dirac (FD) and Bose-Einstein (BE) integrals.
%
% Refs.:
% [1] Bhagat, Vikram, Ranjan Bhattacharya, and Dhiranjan Roy. "On the
%     evaluation of generalized Bose-Einstein and Fermi-Dirac integrals."
%     Computer physics communications 155.1 (2003): 7-20. 
% [2] Maximilian Kuhnert. "Enhanced computation of polylogarithm aka de
%     jonquieres function." Matlab File Exchange #37229, polylog.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program and its subprograms may be freely used, modified and
% distributed under the GNU General Public License: 
% http://www.gnu.org/copyleft/gpl.html   
%
% Basic Assumptions:
% n: is a positive rational or interger value.
% z: can be is a single value or vector array.
%
%% Solution Procedure
if mod(n,1)==0; 
    g = real(polylog(n,z)); % if n:integer, the use matlab built in polylog function
else
% 4 approximations are given for PolyLog(n,z) depending on the value of z
id1=find(z>=0.55); z1=z(id1);         %Range 1:  0.55 >= z >= 1.0 : BE int
id2=find(z>0&z<0.55); z2=z(id2);      %Range 2:     0 >= z > 0.55 : BE int
id3=find(z<=0&z>-50); z3=abs(z(id3)); %Range 3:    -50 < z < 0.0  : FD int
id4=find(z<=-50); z4=abs(z(id4));     %Range 4:-100000 < z <-50.0 : FD int
g=zeros(size(z));   % Solution Array

%% Solution Method z-Range 1
alpha = -log(z1);    b = @(i) zeta(n-i);
preterm = gamma(1-n)./alpha.^(1-n);
nominator = b(0) + ...
    - alpha.*( b(1) - 4*b(0)*b(4)/7/b(3) ) + ...
    + alpha.^2.*( b(2)/2 + b(0)*b(4)/7/b(2) - 4*b(1)*b(4)/7/b(3) ) + ...
    - alpha.^3.*( b(3)/6 - 2*b(0)*b(4)/105/b(1) + b(1)*b(4)/7/b(2) - 2*b(2)*b(4)/7/b(3) );
denominator = 1 + alpha.*4*b(4)/7/b(3) +...
    + alpha.^2.*b(4)/7/b(2) +...
    + alpha.^3.*2*b(4)/105/b(1) +...
    + alpha.^4.*b(4)/840/b(0);
g1 = preterm + nominator ./ denominator; g(id1)=g1; %disp(g1)

%% Solution Method z-Range 2
%S = @(nu,zz,j) sum( (zz.^(1:j))./((1:j).^nu) );
nominator = 6435*9^n.*BE(n,z2,8) - 27456*8^n*z2.*BE(n,z2,7) + ...
    + 48048*7^n*z2.^2.*BE(n,z2,6) - 44352*6^n*z2.^3.*BE(n,z2,5) + ...
    + 23100*5^n*z2.^4.*BE(n,z2,4) - 6720*4^n.*z2.^5.*BE(n,z2,3) + ...
    + 1008*3^n*z2.^6.*BE(n,z2,2) - 64*2^n*z2.^7.*BE(n,z2,1);
denominator = 6435*9^n - 27456*8^n*z2 + ...
    + 48048*7^n*z2.^2 - 44352*6^n*z2.^3 + ...
    + 23100*5^n*z2.^4 - 6720*4^n*z2.^5 + ...
    + 1008*3^n*z2.^6 - 64*2^n*z2.^7 + ...
    + z2.^8;
g2 = nominator ./ denominator; g(id2)=g2; %disp(g2)

%% Solution Method z-Range 3
%S = @(nu,zz,j) sum( ((-1).^((1:j)-1)).*(zz.^(1:j))./((1:j).^nu) );
nominator = 6435*9^n.*FD(n,z3,8) + 27456*8^n*z3.*FD(n,z3,7) + ...
    + 48048*7^n*z3.^2.*FD(n,z3,6) + 44352*6^n*z3.^3.*FD(n,z3,5) + ...
    + 23100*5^n*z3.^4.*FD(n,z3,4) + 6720*4^n.*z3.^5.*FD(n,z3,3) + ...
    + 1008*3^n*z3.^6.*FD(n,z3,2) + 64*2^n*z3.^7.*FD(n,z3,1);
denominator = 6435*9^n + 27456*8^n*z3 + ...
    + 48048*7^n*z3.^2 + 44352*6^n*z3.^3 + ...
    + 23100*5^n*z3.^4 + 6720*4^n*z3.^5 + ...
    + 1008*3^n*z3.^6 + 64*2^n*z3.^7 + ...
    + z3.^8;
g3 = - nominator ./ denominator; g(id3)=g3; %disp(g3)

%% Solution Method z-Range 4
% Asymptotic expansion known as Sommerfeld's lemma.
xi = log(z4); 
preterm = (xi.^n)./gamma(n+1);
series = 1 + n.*(n-1).*(pi^2/6).*(1./xi.^2) + ...
    n.*(n-1).*(n-2).*(n-3).*(7*pi^4/360).*(1./xi.^4);
g4 = - preterm .* series; g(id4)=g4; %disp(g4)
end

%% Define Internal functions
    % Bose-Einstein Function
    function out = BE(nu,zz,j)
        out = zeros(size(zz)); for l=1:j; out = out + zz.^l./l^nu; end
    end

    % Fermi-Dirac Function
    function out = FD(nu,zz,j)
        out = zeros(size(zz)); for l=1:j; out = out + (-1).^(l-1).*zz.^l./l^nu; end
    end

    % Zeta Function
    function Z = zeta(n)
        eta = @(nu,j) sum( ((-1).^((1:j)+1))./((1:j).^nu) );
        prefactor = 2^(n-1)/( 2^(n-1)-1 );
        numerator = 1 + 36*2^n*eta(n,2) + 315*3^n*eta(n,3) + 1120*4^n*eta(n,4) +...
            + 1890*5^n*eta(n,5) + 1512*6^n*eta(n,6) + 462*7^n*eta(n,7);
        denominator = 1 + 36*2^n + 315*3^n + 1120*4^n + 1890*5^n + 1512*6^n +...
            + 462*7^n;
        Z = prefactor * numerator / denominator;
    end
    
end