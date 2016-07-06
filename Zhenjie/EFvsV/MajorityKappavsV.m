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
fileS1='05-16-2016_19_44_43_top';
[~,~,~,VsortS1,~,~,~,EFS1]=EOS_Online( [filefolder_Polarized,fileS1,'.fits'] ,'ROI1',[157,50,390,450],...
    'ROI2',[157,130,390,320],'TailRange',[90,410],'ShowOutline',1,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.05,...
    'Fudge',2.8,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',330,'ShowPlot',1,'CutOff',inf,'IfHalf',0);

%%
filefolder_Polarized='/Users/Zhenjie/Data/2016-05-16/';
fileS1List={'05-16-2016_19_12_21_top';'05-16-2016_19_10_37_top';'05-16-2016_19_08_51_top';'05-16-2016_19_07_07_top';'05-16-2016_19_05_21_top';'05-16-2016_19_03_37_top';'05-16-2016_19_01_51_top';'05-16-2016_18_57_27_top';'05-16-2016_18_54_42_top';'05-16-2016_18_52_57_top';'05-16-2016_18_48_55_top';'05-16-2016_18_47_10_top';'05-16-2016_18_44_49_top';'05-16-2016_18_43_05_top'};
VsortS1List={};
EFS1List={};
for i=1:length(fileS1List)
    [~,~,~,VsortS1,~,~,~,EFS1]=EOS_Online( [filefolder_Polarized,fileS1List{i},'.fits'] ,'ROI1',[157,50,390,450],...
     'ROI2',[157,150,390,350],'TailRange',[90,410],'ShowOutline',0,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.15,...
    'Fudge',1.6,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',330,'ShowPlot',0,'CutOff',inf,'IfHalf',0);
    VsortS1List=[VsortS1List;VsortS1];
    EFS1List=[EFS1List;EFS1];
end
%%
plot(VsortS1List{2}/hh,EFS1List{2}/hh,'r.');
hold on
plot(VsortS1List{5}/hh,EFS1List{5}/hh,'b.');
plot(VsortS1List{7}/hh,EFS1List{7}/hh,'g.');
hold off
%%
VsortS1=[];
EFS1=[];

for i=1:length(fileS1List)
    VsortS1=[VsortS1;VsortS1List{i}];
    EFS1=[EFS1;EFS1List{i}];
end
VsortS1=VsortS1/hh;
EFS1=EFS1/hh;
%%
plot(VsortS1,EFS1,'r.');
xlabel('V (Hz)');ylabel('EF (Hz)');
title('Majority, EF vs V');
%%
Nbin=140;
%Vgrid=linspace(0,sqrt(max(VsortS1)),Nbin+1).^2;
Vgrid=linspace(0,1.3e4,Nbin+1);


[VS1Bin,EFS1Bin,VS1Err,EFS1Err]=BinGrid(VsortS1,EFS1,Vgrid,2);

mask=isnan(EFS1Bin);
VS1Bin(mask)=[];
EFS1Bin(mask)=[];
VS1Err(mask)=[];
EFS1Err(mask)=[];

errorbar(VS1Bin,EFS1Bin,EFS1Err,'r.');
xlabel('V (Hz)');ylabel('EF (Hz)');
title('Majority, EF vs V, Binned');
%%
[kappa1T,kappa1Terr] = FiniteD( VS1Bin,VS1Err,EFS1Bin,EFS1Err,4);
kappa1T=-kappa1T;
errorbar(VS1Bin,kappa1T,kappa1Terr,'r.');
hold on
line([800,800],[-0.2e4,1e4])
hold off
xlim([0,16000]);ylim([-0.2,1.4]);
xlabel('V (Hz)');ylabel('KappaTilde');
title('Majority, after averaging');
xlim([0,12000]);
%% Get the T from the kappa,
Vth1=6000;
Vth2=8000;
mask1=VS1Bin>Vth1;mask2=VS1Bin<Vth2;
mask=mask1 & mask2;

[ KappaTildeT, PTildeT, TTildeT] = IdealFermiEOS( );
VSample=VS1Bin(mask);
EFSample=EFS1Bin(mask);
kappaSample=kappa1T(mask);
TtildeSample=interp1(KappaTildeT,TTildeT,kappaSample,'spline');
TSample=TtildeSample.*EFSample;
scatter(VSample,TSample);
hold on
line([Vth1,Vth2],[770,770],'color','r')
hold off
ylim([0,1500]);
T=mean(TSample)
title('Temperature get from \kappa/\kappa_0');
ylabel('k_B T (Hz)');xlabel('V(Hz)');
%% Also get the T from P/P0
np=real(EFS1Bin.^(3/2));
P=np*0;
for i=1:(length(P)-1)
    P(i)=real(trapz(VS1Bin(i:end),np(i:end)));
end
P0=0.4*np.*EFS1Bin;
P1T=P./P0;
% scatter(VS1Bin,P1T);
% ylim([0,5]);

Vth1=1000;
Vth2=8000;
mask1=VS1Bin>Vth1;mask2=VS1Bin<Vth2;
mask=mask1 & mask2;
VSample=VS1Bin(mask);
EFSample=EFS1Bin(mask);
PSample=P1T(mask);
TtildeSample=interp1(PTildeT,TTildeT,PSample,'spline');
TSample=TtildeSample.*EFSample;
scatter(VSample,TSample);
ylim([0,2000]);
T=mean(TSample)
ylabel('k_B T (Hz)');xlabel('V(Hz)');
title('Temperature get from P/P_0');



%% plot EF vs V
Nbin=200;
%Vgrid=linspace(0,sqrt(max(VsortS1)),Nbin+1).^2;
Vgrid=linspace(0,1.2e4,Nbin+1);

[VS1Plot,EFS1Plot,VS1PlotErr,EFS1PlotErr]=BinGrid(VsortS1,EFS1,Vgrid,2);

mask=isnan(EFS1Bin);
VS1Plot(mask)=[];
EFS1Plot(mask)=[];
VS1PlotErr(mask)=[];
EFS1PlotErr(mask)=[];

% fit a line to the plateau
mask1=VS1Plot>2000;
mask2=VS1Plot<5000;
mask=mask1 & mask2;
Vfit=VS1Plot(mask);
EFfit=EFS1Plot(mask);

P=polyfit(Vfit,EFfit,1);
Vpfit=linspace(0,8000,100);
EFpfit=polyval(P,Vpfit);

figure1 = figure;
axes1 = axes('Parent',figure1,'unit','inch','position',[1,1,1.4,1.4]);
plot(VS1Plot/1e3,EFS1Plot/1e3,'linewidth',1,'color',[36/255,85/255,189/255])
hold on
%plot(Vpfit/1e3,EFpfit/1e3,'--','linewidth',1);
hold off
xlabel('V (kHz)');ylabel('EF (kHz)');
title('Majority, EF vs V, Binned');
% Set the remaining axes properties
ylim([-0.5,6]);xlim([2.5,12]);
set(axes1,'XTick',[3 5 7 9 11],'YTick',[0 2 4 6]);
set(axes1,'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0])
savefig(figure1,'MajorityEFvsV.fig');
print(figure1,'MajorityEFvsV','-dpdf');
%% Fit a exponential function to the tail of the cloud to determine the temperature
FitRangeExp=linspace(6000,8000,50);
Tfitexp=FitRangeExp*0;
Kiexp=FitRangeExp*0;
fitfun=@(p,x) p(1)*exp(-p(2)*x);
amp=FitRangeExp*0;
offsetexp=FitRangeExp*0;
for i=1:length(FitRangeExp)
    mask=VS1Bin>FitRangeExp(i);
    Vfitexp=VS1Bin(mask);
    EFfitexp=EFS1Bin(mask);
    P0=[3.6e5,0.66*(1/T),0];
    P=nlinfit(Vfitexp,EFfitexp,fitfun,P0);
    Tfitexp(i)=0.66*(1/P(2));
    EFfittedexp=fitfun(P,Vfitexp);
    Kiexp(i)=mean((EFfittedexp-EFfitexp).^2);
    %offsetexp(i)=P(3);
    amp(i)=P(1);
end
%%
scatter(FitRangeExp,Kiexp);
xlabel('Fit Range (Hz)');ylabel('Fitting Error')
%%
scatter(FitRangeExp,Tfitexp);
xlabel('Fit Range (Hz)');ylabel('Fitted Temperature (Hz)')
%%
mask=VS1Bin>FitRangeExp(i);
Vfitexp=VS1Bin(mask);
EFfitexp=EFS1Bin(mask);
P0=[3.6e5,0.66*(1/T),0];
P=nlinfit(Vfitexp,EFfitexp,fitfun,P0);
Tfitexp(i)=0.66*(1/P(2));
EFfittedexp=fitfun(P,Vfitexp);
EFtailfit=EFS1Bin;
EFtailfit(mask)=EFfittedexp;

%% plot kappa vs V
TTilde_T=770./EFtailfit;
% mask=EFS1Bin<20;
% TTilde_T(mask)=25;
KappaTilde_T=interp1(TTildeT,KappaTildeT,TTilde_T,'spline');


figure1 = figure;
axes1 = axes('Parent',figure1,'unit','inch','position',[1,1,4.8,4.8]);
errorbar1derr_Z(VS1Bin/1e3,kappa1T,kappa1Terr,'LineStyle','none','Markersize',15,'Color','r');
hold on
line([800,800],[-0.2e1,1e1])
plot(VS1Bin/1e3,KappaTilde_T,'k-')
hold off
xlim([0,12]);ylim([-0.3,1.4]);
xlabel('V (Hz)');ylabel('KappaTilde');
set(axes1,'XTick',[2 4 6 8 10 12],'YTick',[0 1]);
savefig(figure1,'MajorityKappavsV.fig');
print(figure1,'MajorityKappavsV','-dpdf');

%% Do the deriviative to every single shot and then average
KappaList={};
VBinList={};
VStackList=[];
KappaStackList=[];
Nbin=120;
Vgrid=linspace(0,1.3e4,Nbin+1);

for i=1:length(VsortS1List)
    [VtempBin,EFtempBin,~,~]=BinGrid(VsortS1List{i}/hh,EFS1List{i}/hh,Vgrid,0);
    VtempBin(isnan(VtempBin))=[];EFtempBin(isnan(EFtempBin))=[];
    VBinList=[VBinList;VtempBin];
    KappaTemp=FiniteD(VtempBin,VtempBin*0,EFtempBin,EFtempBin*0,3);
    KappaTemp=-KappaTemp;
    KappaList=[KappaList;KappaTemp];
    VStackList=[VStackList,VtempBin];
    KappaStackList=[KappaStackList,KappaTemp];
end
%%
scatter(VStackList,KappaStackList)
%%

[VS_D,Kappa_D,VS_DErr,Kappa_DErr]=BinGrid(VStackList,KappaStackList,Vgrid,0);
errorbar(VS_D,Kappa_D,Kappa_DErr,'r.')
hold on
line([800,800],[-0.2e4,1e4])
hold off
xlim([0,16000]);ylim([-0.2,1.4]);
xlabel('V (Hz)');ylabel('KappaTilde');
title('Majority, after averaging');
xlim([0,12000]);


%% plot kappa vs V
Nmask=2;
mask=1:Nmask:length(VS_D);
figure1 = figure;
axes1 = axes('Parent',figure1,'unit','inch','position',[1,1,1.4,1.4]);
errorbar1derr_Z(VS_D(mask)/1e3,Kappa_D(mask),Kappa_DErr(mask),'Marker','.','Markersize',5,'LineStyle','none','ErrLineWidth',0.75,'MarkerFaceColor',[255/255,85/255,65/255],'MarkerEdgeColor',[255/255,85/255,65/255],'ErrBarColor',[201/255,67/255,52/255]);
hold on
%plot(VS1Bin/1e3,KappaTilde_T)
hold off
xlim([2.5,12]);ylim([-0.1,1.1]);
xlabel('V (Hz)');ylabel('KappaTilde');
set(axes1,'XTick',[3 5 7 9 11],'YTick',[0 0.25 0.5 0.75 1]);
set(axes1,'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0])
box on
savefig(figure1,'MajorityKappavsV_D.fig');

