%% Preloading
%Define the physical constant
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
kB=1.38e-23;
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
Vr= @(r,r0) V0*(r/r0).^1000;
n3D=zeros(512,512,512);
[Xmesh Ymesh Zmesh]=meshgrid(x,y,z);
%%
% [ TTildeU, CVU, PTildeU, KappaTildeU, mu_EF_U ] ...
%     = SimulatedUnitarity( );
% beta_mu_U=mu_EF_U./TTildeU;
% save('EOSUnitary.mat','TTildeU','CVU','PTildeU','KappaTildeU','mu_EF_U','beta_mu_U');

load('EOSUnitary.mat')
%% get the x,y profile at z=0
[X0,Y0]=meshgrid(x,y);
R0=(X0.^2+Y0.^2).^(1/2);
Vr0=Vr(R0,r0);
mu=mu0-Vr0;
TTilde0=interp1(beta_mu_U(2:end),TTildeU(2:end),mu/Ttrap,'spline');
EF=((1./TTilde0)*Ttrap)/hh;
n=((1./TTilde0)*Ttrap).^(3/2)*(2*mli/hbar^2)^(3/2)/(6*pi^2);

n(mu/Ttrap<min(beta_mu_U))=0;
imagesc(n)
EFtrap=max(EF(:));

%%
Vz=0.5*mli*omega^2*z.^2;
muz=mu0-Vz;
r0z=r0+sin(angle/2)*z;
%% Get the thermal dynamic quantities at different V
bmuz=muz/Ttrap;
Pz=interp1(beta_mu_U(2:end),PTildeU(2:end),bmuz,'spline');
kappaz=interp1(beta_mu_U(2:end),KappaTildeU(2:end),bmuz,'spline');
Tz=interp1(beta_mu_U(2:end),TTildeU(2:end),bmuz,'spline');
EFz=Ttrap./Tz;
%%
for i=1:512
    [Xz,Yz]=meshgrid(x,y);
    Rz=(Xz.^2+Yz.^2).^(1/2);
    Vrz=Vr(Rz,r0z(i));
    mu=muz(i)-Vrz;
    TTildez=interp1(beta_mu_U(2:end),TTildeU(2:end),mu/Ttrap,'spline');
    EFz=((1./TTildez)*Ttrap)/hh;
    nz=((1./TTildez)*Ttrap).^(3/2)*(2*mli/hbar^2)^(3/2)/(6*pi^2);
    nz(mu/Ttrap<min(beta_mu_U))=0;
    n3D(:,:,i)=nz;
    disp(i)
end

%%
N3D=n3D*pixellength^3;
Nxy=N3D(:,:,z==0);

N2D=squeeze(sum(N3D,2))';
imagesc(N2D);
Ttilde_trap=Ttrap_khz/EFtrap;
%save(['Ttilde_trap=',num2str(Ttilde_trap),'_Cone.mat'],'N2D','Vz','Pz','kappaz','Ttrap','mu0');
%%
%load('SimulatedFigures/Ttilde_trap=0.068214_Cone.mat');
[Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,EFsort,P,zcor] = EOS_Online(N2D,'Fudge',1,'ROI1',[160,5,350,490],'ROI2',[160,185,350,320],'KappaMode',5,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,...
    'BGSubtraction',0,'IfFitExpTail',0,'IfBin',1,'SM',1,'ShowPlot',1,'CutOff',inf,'IfHalf',0);
%%
scatter(Pt,Kt);
hold on
plot(PTildeU,KappaTildeU)
hold off
xlim([0,5]);ylim([0,3.7])
%%
plot(Vsort/hh,Pt,'r.','markersize',9);
hold on
plot(Vz/hh,Pz)
hold off
ylim([0,5])
xlabel('U (kHz)');ylabel('P/P_0')
%%
plot(Vsort,Kt,'r.','markersize',9);
hold on
plot(Vz,kappaz)
hold off
ylim([0,5])
%%
%filelist={'Ttilde_trap=0.068214.mat';'Ttilde_trap=0.15888.mat';'Ttilde_trap=0.25917.mat';'Ttilde_trap=0.26959.mat'};
%filelist={'Ttilde_trap=0.06617_Sharp.mat';'Ttilde_trap=0.15224_Sharp.mat';'Ttilde_trap=0.18918_Sharp.mat';'Ttilde_trap=0.38342_Sharp.mat';'Ttilde_trap=0.6192_Sharp.mat';'Ttilde_trap=0.73979_Sharp.mat';'Ttilde_trap=1.5743_Sharp.mat'};
%filelist={'Ttilde_trap=0.068214_Sharp_Cone.mat';'Ttilde_trap=0.15888_Sharp_Cone.mat';'Ttilde_trap=0.38342_Sharp_Cone.mat';'Ttilde_trap=0.6192_Sharp_Cone.mat';'Ttilde_trap=0.73979_Sharp_Cone.mat';'Ttilde_trap=1.5743_Sharp_Cone.mat'};
filelist={'Ttilde_trap=0.068214_Cone.mat';'Ttilde_trap=0.10803_Cone.mat';'Ttilde_trap=0.15888_Cone.mat';'Ttilde_trap=0.38342_Cone.mat';'Ttilde_trap=0.6192_Cone.mat';'Ttilde_trap=1.0742_Cone.mat';'Ttilde_trap=1.5743_Cone.mat'};
%filelist=filelist(1:3);
N=length(filelist);
Ptlist=[];
Ktlist=[];
for i=1:N
    load(['SimulatedFigures/',filelist{i}]);
    [Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,EFsort,P,zcor,Vsel] = EOS_Online(N2D,'Fudge',1,'ROI1',[160,10,350,500],'ROI2',[160,185,350,320],'KappaMode',5,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,...
    'BGSubtraction',0,'IfFitExpTail',1,'IfBin',1,'SM',1,'ShowPlot',0,'CutOff',inf,'IfHalf',0,'TailRange',[10,490],'ShowOutline',0,'kmax',0.8,'kmin',0.1);
    %Ptuse=interp1(Vz(256:512),Pz(256:512),Vsel);
    Ptlist=[Ptlist;Ptsel];
    Ktlist=[Ktlist;Ktsel];
end
%%
scatter(Ptlist,Ktlist,'ro')
hold on
plot(PTildeU,KappaTildeU,'b-');
hold off
xlim([0,6])
ylim([0,4])
xlabel('P/P_0');
ylabel('\kappa/\kappa_0')
%%
Pgrid=linspace(sqrt(0.35),sqrt(4.2),200).^2;
%Pgrid=linspace(0.35,4.2,200);
[ PTildeM,KTildeM,~,~ ] = BinGrid( Ptlist,Ktlist,Pgrid,0 );
plot(PTildeM,KTildeM,'ro');
hold on
plot(PTildeU,KappaTildeU,'b-');
hold off
xlim([0,6])
ylim([0,4])
%%
KtU=KTildeM;PtU=PTildeM;
% the cutoff value for the pressure.
Ptcutoff=4;
Ttcutoff=interp1(PTildeU,TTildeU,Ptcutoff);

KtU(PtU>Ptcutoff)=[];
PtU(PtU>Ptcutoff)=[];
PtU(isnan(KtU))=[];
KtU(isnan(KtU))=[];

Ttcutoff=interp1(PTildeU,TTildeU,max(PtU));

TtU=GetTTilde(PtU,KtU,Ttcutoff);
Cvt_PKTU = GetCvTilde( PtU,KtU,TtU );

%%
plot(TtU,Cvt_PKTU,'ro');
hold on
line([0.17,0.17],[0,3],'color','k','linewidth',2);
plot(TTildeU,CVU)
hold on
xlim([0,1.8])
xlabel('T/T_F');
ylabel('C_V/k_B N')