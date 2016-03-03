%%Try different fitting mothed by fitting to the simulatted polarized gas
%define all the physical constant here:
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
Nsat=330; %PI Camera
warning('off','all');
[ KappaTildeT, PTildeT, Z_vecT ] = IdealFermiEOS( 1.1,30, 5000 );

load('MultipleTSimulated_noise');
N=length(n_simulated_noise_list_multiT);
Ptlist=[];
Ktlist=[];
for i=1:N
    [~,~,~,~,~,Ptsel,Ktsel] = ...
    GenerateEoS( n_simulated_noise_list_multiT{i},y_vec, mli,omega,2,0.15,1,20,4);
    Ptlist=[Ptlist,Ptsel];
    Ktlist=[Ktlist,Ktsel];
end

scatter(Ptlist,Ktlist,'r.');
hold on
plot(PTildeT,KappaTildeT);
hold off