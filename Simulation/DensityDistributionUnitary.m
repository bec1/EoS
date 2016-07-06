%% Preloading
%Define the physical constant
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
%load all the functions
addpath('/Users/Zhenjie/Github/EoS/Zhenjie/Library');
addpath('/Users/Zhenjie/Github/SimulatedEOSunitarity');
%% Define the cloud
mu0_hz=3500; %mu(z=0) at center of cloud in unit of kHz
Ttrap_khz=600; % Temperature of the cloud in kHz
mu0=mu0_hz*hh;
Ttrap=Ttrap_khz*hh;
r0=60e-6; %The trap radius at z=0 in microron
angle=0/180*pi; %The angle of the cone
xgrid=-255:256;ygrid=-255:256;zgrid=-255:256;
x=xgrid*pixellength;y=ygrid*pixellength;z=zgrid*pixellength;
V0=6000*hh;
Vr= @(r,r0) V0*(r/r0).^16;
n3D=zeros(512,512,512);
[Xmesh Ymesh Zmesh]=meshgrid(x,y,z);
%%
[ TTildeU, CVU, PTildeU, KappaTildeU, mu_EF_U ] ...
    = SimulatedUnitarity( );
beta_mu_U=mu_EF_U./TTildeU;
%% get the x,y profile at z=0
[X0,Y0]=meshgrid(x,y);
R0=(X0.^2+Y0.^2).^(1/2);
Vr0=Vr(R0,r0);
mu=mu0-Vr0;
TTilde0=interp1(beta_mu_U(2:end),TTildeU(2:end),mu/Ttrap,'spline');
EF=((1./TTilde0)*Ttrap)/hh;
n=((1./TTilde0)*Ttrap).^(3/2)*(2*mli/hbar^2)^(3/2)/(6*pi^2);

n(mu/Ttrap<min(beta_mu_P))=0;
imagesc(n)
EFtrap=max(EF(:));
%%
Vz=0.5*mli*omega^2*z.^2;
muz=mu0-Vz;
r0z=r0+sin(angle/2)*z;
for i=1:512
    [Xz,Yz]=meshgrid(x,y);
    Rz=(Xz.^2+Yz.^2).^(1/2);
    Vrz=Vr(Rz,r0z(i));
    mu=muz(i)-Vrz;
    TTildez=interp1(beta_mu_U(2:end),TTildeU(2:end),mu/Ttrap,'spline');
    EFz=((1./TTildez)*Ttrap)/hh;
    nz=((1./TTildez)*Ttrap).^(3/2)*(2*mli/hbar^2)^(3/2)/(6*pi^2);
    nz(mu/Ttrap<min(beta_mu_P))=0;
    n3D(:,:,i)=nz;
    disp(i)
end

%%
N3D=n3D*pixellength^3;
Nxy=N3D(:,:,z==0);

N2D=squeeze(sum(N3D,2))';
imagesc(N2D);
Ttilde_trap=Ttrap_khz/EFtrap;
save(['Ttilde_trap=',num2str(Ttilde_trap)]);
%%
[Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,EFsort,P,zcor] = EOS_Online(N2D,'Fudge',1,'ROI1',[160,50,350,460],'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,...
    'BGSubtraction',0,'IfFitExpTail',0,'IfBin',1,'SM',4,'ShowPlot',1,'CutOff',inf,'IfHalf',0);