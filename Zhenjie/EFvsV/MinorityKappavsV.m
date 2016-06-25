%% Preloading
%Define the physical constant
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
%load all the functions
addpath('../Library');

%%
filefolder_Polarized='/Users/Zhenjie/Data/2016-05-16/';
fileS2List={'05-16-2016_19_13_13_top';'05-16-2016_19_11_29_top';'05-16-2016_19_06_13_top';'05-16-2016_19_04_29_top';'05-16-2016_18_53_50_top';'05-16-2016_18_48_02_top';'05-16-2016_18_45_42_top'};
VsortS2List={};
EFS2List={};
for i=1:length(fileS2List)
    [~,~,~,VsortS2,~,~,~,EFS2]=EOS_Online( [filefolder_Polarized,fileS2List{i},'.fits'] ,'ROI1',[157,50,390,450],...
    'ROI2',[157,220,390,280],'TailRange',[150,350],'ShowOutline',0,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.15,...
    'Fudge',2.8,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',330,'ShowPlot',0,'CutOff',inf,'IfHalf',0);
    VsortS2List=[VsortS2List;VsortS2];
    EFS2List=[EFS2List;EFS2];
end
%%
plot(VsortS2List{1}/hh,EFS2List{1}/hh,'r.','markersize',10);
hold on
plot(VsortS2List{2}/hh,EFS2List{2}/hh,'b.','markersize',10);
plot(VsortS2List{3}/hh,EFS2List{3}/hh,'g.','markersize',10);
xlim([0,6000]);xlabel('V (Hz) Unshifted');ylabel('E_F(Hz)');
title('Minority unbinned');
hold off

%%
VsortS2=[];
EFS2=[];

for i=1:length(fileS2List)
    VsortS2=[VsortS2;VsortS2List{i}];
    EFS2=[EFS2;EFS2List{i}];
end
VsortS2=VsortS2/hh;
EFS2=EFS2/hh;
%%
plot(VsortS2,EFS2,'r.');
xlabel('V (Hz)');ylabel('EF (Hz)');
title('Put Several images together');

%%
Nbin=100;
%Vgrid=linspace(0,sqrt(max(VsortS1)),Nbin+1).^2;
Vgrid=linspace(0,6e3,Nbin+1);


[VS2Bin,EFS2Bin,VS2Err,EFS2Err]=BinGrid(VsortS2,EFS2,Vgrid,0);

errorbar(VS2Bin,EFS2Bin,EFS2Err,'r.');
xlabel('V (Hz)');ylabel('EF (Hz)');
title('Minority, Binned');

mark=isnan(EFS2Bin);
VS2Bin(mark)=[];
EFS2Bin(mark)=[];
EFS2Err(mark)=[];
%%
EFS1grid2=interp1(VS1Bin,EFS1Bin,VS2Bin,'spline','extrap');
VmS2=VS2Bin-0.615*EFS1grid2;

plot(VmS2,EFS2Bin,'r.');
xlabel('V modified(Hz)');ylabel('E_F (Hz)');
title('Minority, potential modified by the majority')


%%
[kappa2T,kappa2Terr] = FiniteD( VmS2,0*VmS2,EFS2Bin,EFS2Err,3 );
kappa2T=-kappa2T;
errorbar(VS2Bin,kappa2T,kappa2Terr,'r.');
xlim([0,5000]);
xlabel('V (Hz)');ylabel('KappaTilde');
title('Minority, after averaging');
%%
[kappa2T,kappa2Terr] = FiniteD( VmS2,0*VmS2,EFS2Bin,EFS2Err,3 );
kappa2T=-kappa2T;
errorbar(VmS2,kappa2T,kappa2Terr,'r.');

xlabel('V modified (Hz)');ylabel('KappaTilde');
title('Minority, after averaging');

%%
N=60;
index=2:N;
Slope=index*0;
Err=index*0;
for i=2:N
    X=VmS2(1:i);
    Y=EFS2Bin(1:i);
    P=polyfit(X,Y,1);
    f = polyval(P,X);
    Err(i-1) = mean((f-Y).^2);
    Slope(i-1)=-P(1);
end

scatter(VmS2(index),Slope)
xlabel('Fitting Range, V_{modified} (Hz)');
ylabel('Fitted Slope')
%%
scatter(VmS2(index),Err)
ylabel('\chi');xlabel('Fitting Range, V_{modified} (Hz)');
%xlim([-2500,-1000])
%% Get the binning for every shots
VS2BinList={};
EFS2BinList={};
VmS2List={};
KappaS2List={};
Nbin=100;
Vgird=linspace(0,5e3,Nbin+1);
for i=1:length(EFS2List)
    [VBin,EFBin]=BinGrid(VsortS2List{i}/hh,EFS2List{i}/hh,Vgird,0);
    mark=isnan(EFBin);
    VBin(mark)=[];
    EFBin(mark)=[];
    VS2BinList=[VS2BinList;VBin];
    EFS2BinList=[EFS2BinList;EFBin];
    EFS1=interp1(VS1Bin,EFS1Bin,VBin,'spline','extrap');
    Vm=VBin-0.615*EFS1;
    VmS2List=[VmS2List;Vm];
    Kappa=FiniteD(Vm,Vm*0,EFBin,EFBin*0,4);
    Kappa=-Kappa;
    KappaS2List=[KappaS2List;Kappa];
    disp(i);
end
%%
plot(VmS2List{1},KappaS2List{1},'r.','markersize',10);
hold on
plot(VmS2List{4},KappaS2List{4},'b.','markersize',10);
plot(VmS2List{7},KappaS2List{7},'g.','markersize',10);
xlim([-3000,3000])
%%
VmS2_vector=[];
KappaS2_vector=[];
for i=1:length(VmS2List)
    VmS2_vector=[VmS2_vector,VmS2List{i}];
    KappaS2_vector=[KappaS2_vector,KappaS2List{i}];
end
scatter(VmS2_vector,KappaS2_vector);
%%
Nbin=100;
Vmgrid=linspace(min(VmS2_vector),max(VmS2_vector),Nbin+1);
[VmS2_avg,KappaS2_avg,~,KappaS2_err]=BinGrid(VmS2_vector,KappaS2_vector,Vmgrid,0);
errorbar(VmS2_avg,KappaS2_avg,KappaS2_err,'r.');
ylim([-0.3,1.5]);
xlabel('V modified (Hz)');ylabel('KappaTilde');
title('Averaged KappaTilde');
%%
VmList={};
for i=1:length(VsortS2List)
    VS2=VsortS2List{i}/hh;
    EF1=interp1(VS1Bin,EFS1Bin,VS2,'spline','extrap');
    EF1(VS2>max(VS1Bin))=0;
    Vm=VS2-0.615*EF1;
    VmList=[VmList;Vm];
end

%%
Slopelist=[];
fittingrange=-3250;
for i=1:length(VmList)
    Vm=VmList{i};
    EF=EFS2List{i}/hh;
    mask=Vm<fittingrange;
    X=Vm(mask);
    Y=EF(mask);
    P=polyfit(X,Y,1);
    Slopelist=[Slopelist,-P(1)];
end
mean(Slopelist)
std(Slopelist)/sqrt(length(Slopelist)-1)
(max(EFS2Bin)/max(EFS1Bin))^1.5

%% The minority vs V;

Nbin=100;
%Vgrid=linspace(0,sqrt(max(VsortS1)),Nbin+1).^2;
Vgrid=linspace(0,5e3,Nbin+1);


[VS2Plot,EFS2Plot,VS2PlotErr,EFS2PlotErr]=BinGrid(VsortS2,EFS2,Vgrid,0);

figure1 = figure;
axes1 = axes('Parent',figure1);
plot(VS2Plot/1e3,EFS2Plot/1e3,'r','linewidth',2)
xlabel('V (kHz)');ylabel('EF (kHz)');
title('Majority, EF vs V, Binned');
% Set the remaining axes properties
set(axes1,'XTick',[0 1 2 3 4],'YTick',[0 2 4 6 8]);
ylim([-0.5,8]);xlim([0,4]);
savefig(figure1,'MinorityEFvsV.fig');
print(figure1,'MinorityEFvsV','-dpdf');

%% plot the kappa vs V
figure1 = figure;
axes1 = axes('Parent',figure1);
errorbar1derr_Z(VS2Bin/1e3,kappa2T,kappa2Terr,'LineStyle','none','Markersize',15,'Color','b');
line([0,4],[1.1,1.1],'color','r','linestyle','--','linewidth',1)
xlim([0,4]);ylim([-0.2,1.4])
xlabel('V (kHz)');ylabel('KappaTilde');
set(axes1,'XTick',[0 1 2 3 4],'YTick',[0 0.5 1]);
savefig(figure1,'MinorityKappavsV.fig');
print(figure1,'MinorityKappavsV','-dpdf');
%% plot the kappa vs T/T_F
TTilde_minorirty=T./EFS2Bin;
%fit a exponential function to the tail of the minority
Vfit=VS2Bin(VS2Bin>2000);
EFfit=EFS2Bin(VS2Bin>2000);
fitfun=@(P,x) P(1)*exp(-P(2)*x);
P=nlinfit(Vfit,EFfit,fitfun,[1000,0.001]);
EFtail=fitfun(P,Vfit);
EFS2exp=EFS2Bin;
EFS2exp(VS2Bin>2000)=EFtail;
scatter(VS2Bin,EFS2exp);

figure1 = figure;
axes1 = axes('Parent',figure1);
TTilde_minorirty=T./EFS2exp;
errorbar1derr_Z(TTilde_minorirty,kappa2T,kappa2Terr,'Marker','.','LineStyle','none','Markersize',15,'Color','b');
xlim([0.18,30]);
set(axes1,'XTick',[0.2 0.6 1 3 10 30],'YTick',[0 0.5 1]);
set(axes1,'XMinorTick','on','XScale','log');
xlabel('T/T_F');ylabel('\kappa/\kappa_0');
%% Get the Polarization
scatter(VS2Bin,EFS1grid2)
n1=EFS1grid2.^1.5;
n2=EFS2exp.^1.5;
p12=n2./(n1+n2);
scatter(VS2Bin,p12)

Tticks=interp1(VS2Bin,TTilde_minorirty,[0 1 2 3 4]*1e3,'spline','extrap')
pticks=interp1(VS2Bin,p12,[0 1 2 3 4]*1e3,'spline','extrap')