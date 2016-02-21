function [ KappaTilde, PTilde, Z_vec ] = IdealFermiEOS( Zstart, Zstop, Zpoints )
%IdealFermiEOS This function computes the EOS of the Ideal fermi gas
%   The input parameter is the fugacity which defines the range for
%   equation of state. Low Z means high temperature and vice versa for
%   large Z.
%
%   The EOS @ z-> inf is P/P0=K/K0=1 

Z_vec = logspace(Zstart,Zstop,Zpoints);

PTilde = 10*pi/(6*pi^2)^(2/3) * ...
    (-PolyLogFrac(5/2,-Z_vec)./(-PolyLogFrac(3/2,-Z_vec)).^(5/3));

KappaTilde = (6*pi^2)^(2/3)/(6*pi) * ...
    (-PolyLogFrac(1/2,-Z_vec)./(-PolyLogFrac(3/2,-Z_vec)).^(1/3));
    

end

