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
    'Fudge',2.8,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',330,'ShowPlot',0,'CutOff',inf,'IfHalf',0);
    VsortS1List=[VsortS1List;VsortS1];
    EFS1List=[EFS1List;EFS1];
end
%%
plot(VsortS1List{7}/hh,EFS1List{7}/hh,'r.');
hold on
plot(VsortS1List{8}/hh,EFS1List{8}/hh,'b.');
plot(VsortS1List{10}/hh,EFS1List{10}/hh,'g.');
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
xlim([0,12000])
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
ylim([0,1000]);
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

Vth1=000;
Vth2=8000;
mask1=VS1Bin>Vth1;mask2=VS1Bin<Vth2;
mask=mask1 & mask2;
VSample=VS1Bin(mask);
EFSample=EFS1Bin(mask);
PSample=P1T(mask);
TtildeSample=interp1(PTildeT,TTildeT,PSample,'spline');
TSample=TtildeSample.*EFSample;
scatter(VSample,TSample);
ylim([0,1000]);
T=mean(TSample)
ylabel('k_B T (Hz)');xlabel('V(Hz)');
title('Temperature get from P/P_0');
% %% modify the potential
% %%
% EFS2grid1=interp1(VS2Bin,EFS2Bin,VS1Bin,'spline','extrap');
% EFS2grid1(VS1Bin>5000)=0;
% VmS1=VS1Bin-0.691*EFS2grid1;
% scatter(VmS1,EFS1Bin);
% %%
% [kappa1Tm,~] = FiniteD( VmS1,VmS1*0,EFS1Bin,EFS1Err,3 );
% kappa1Tm=-kappa1Tm;
% scatter(VmS1,kappa1Tm)
% xlim([-500,7000])
% ylabel('KappaTilde');xlabel('V_{modified}')
% 
% %%
% Vrange=2000;
% %B=linspace(-0.3,0.3,500);
% B=0.0691;
% Err=B*0;
% mask=VS1Bin<Vrange;
% for i=1:length(B)
%     VmS1=VS1Bin-B(i)*EFS2grid1;
%     X=VmS1(mask);
%     Y=EFS1Bin(mask);
%     P=polyfit(X,Y,1);
%     f=polyval(P,X);
%     Err(i)=mean((f-Y).^2);
% end
% plot(B,Err,'r.');
% xlabel('-B');
% xlim([0,0.1]);
% ylim([0,600]);
% ylabel('\chi of the linear fitting');
% [~,m]=min(Err);
% 
% %% plot EF vs V
% Nbin=200;
% %Vgrid=linspace(0,sqrt(max(VsortS1)),Nbin+1).^2;
% Vgrid=linspace(0,1.2e4,Nbin+1);
% 
% [VS1Plot,EFS1Plot,VS1PlotErr,EFS1PlotErr]=BinGrid(VsortS1,EFS1,Vgrid,2);
% 
% mask=isnan(EFS1Bin);
% VS1Plot(mask)=[];
% EFS1Plot(mask)=[];
% VS1PlotErr(mask)=[];
% EFS1PlotErr(mask)=[];
% 
% figure1 = figure;
% axes1 = axes('Parent',figure1);
% plot(VS1Plot/1e3,EFS1Plot/1e3,'r','linewidth',2)
% xlabel('V (kHz)');ylabel('EF (kHz)');
% title('Majority, EF vs V, Binned');
% % Set the remaining axes properties
% ylim([-0.5,8]);xlim([0,12]);
% set(axes1,'XTick',[0 4 8 12],'YTick',[0 2 4 6 8]);
% savefig(figure1,'MajorityEFvsV.fig');
% print(figure1,'MajorityEFvsV','-dpdf');
% 
% %% plot kappa vs V
% figure1 = figure;
% axes1 = axes('Parent',figure1);
% errorbar1derr_Z(VS1Bin/1e3,kappa1T,kappa1Terr,'LineStyle','none','Markersize',15,'Color','b');
% hold on
% line([800,800],[-0.2e1,1e1])
% hold off
% xlim([0,12]);ylim([-0.2,1.4]);
% xlabel('V (Hz)');ylabel('KappaTilde');
% set(axes1,'XTick',[0 4 8 12],'YTick',[0 0.5 1]);
% savefig(figure1,'MajorityKappavsV.fig');
% print(figure1,'MajorityKappavsV','-dpdf');
% 
