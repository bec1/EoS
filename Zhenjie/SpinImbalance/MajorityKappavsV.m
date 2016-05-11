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
filefolder_Polarized='/Users/Zhenjie/Data/2016-05-06/';
fileS1='05-07-2016_02_05_34_top';
[~,~,~,VsortS1,~,~,~,EFS1]=EOS_Online( [filefolder_Polarized,fileS1,'.fits'] ,'ROI1',[157,50,390,450],...
    'ROI2',[157,220,390,280],'TailRange',[90,410],'ShowOutline',1,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.15,...
    'Fudge',1.6,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',130,'ShowPlot',1,'CutOff',inf);
%%
filefolder_Polarized='/Users/Zhenjie/Data/2016-05-06/';
fileS1List={'05-07-2016_02_05_34_top';'05-07-2016_02_07_18_top';'05-07-2016_02_09_03_top'};
VsortS1List={};
EFS1List={};
for i=1:length(fileS1List)
    [~,~,~,VsortS1,~,~,~,EFS1]=EOS_Online( [filefolder_Polarized,fileS1List{i},'.fits'] ,'ROI1',[157,50,390,450],...
    'ROI2',[157,220,390,280],'TailRange',[90,410],'ShowOutline',0,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.15,...
    'Fudge',1.6,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',130,'ShowPlot',0,'CutOff',inf);
    VsortS1List=[VsortS1List;VsortS1];
    EFS1List=[EFS1List;EFS1];
end
%%
plot(VsortS1List{1},EFS1List{1},'r.');
hold on
plot(VsortS1List{2},EFS1List{2},'b.');
plot(VsortS1List{3},EFS1List{3},'g.');
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
title('Put Several images together');
%%
Nbin=70;
%Vgrid=linspace(0,sqrt(max(VsortS1)),Nbin+1).^2;
Vgrid=linspace(0,1e4,Nbin+1);


[VS1Bin,EFS1Bin,VS1Err,EFS1Err]=BinGrid(VsortS1,EFS1,Vgrid,2);

errorbar(VS1Bin,EFS1Bin,EFS1Err,'r.');
xlabel('V (Hz)');ylabel('EF (Hz)');
title('Put Several images together');
%%
[kappa1T,kappa1Terr] = FiniteD( VS1Bin,VS1Err,EFS1Bin,EFS1Err,4 );
kappa1T=-kappa1T;
errorbar(VS1Bin,kappa1T,kappa1Terr,'r.');
xlim([0,9000]);ylim([-0.2,1.4]);
xlabel('V (Hz)');ylabel('KappaTilde');
title('Majority, after averaging');
%% modify the potential
%%
EFS2grid1=interp1(VS2Bin,EFS2Bin,VS1Bin,'spline','extrap');
EFS2grid1(VS1Bin>5000)=0;
VmS1=VS1Bin-0.0691*EFS2grid1;
scatter(VmS1,EFS1Bin);
%%
[kappa1Tm,~] = FiniteD( VmS1,VmS1*0,EFS1Bin,EFS1Err,3 );
kappa1Tm=-kappa1Tm;
scatter(VmS1,kappa1Tm)
xlim([-500,7000])
ylabel('KappaTilde');xlabel('V_{modified}')

%%
Vrange=2000;
%B=linspace(-0.3,0.3,500);
B=0.0691;
Err=B*0;
mask=VS1Bin<Vrange;
for i=1:length(B)
    VmS1=VS1Bin-B(i)*EFS2grid1;
    X=VmS1(mask);
    Y=EFS1Bin(mask);
    P=polyfit(X,Y,1);
    f=polyval(P,X);
    Err(i)=mean((f-Y).^2);
end
plot(B,Err,'r.');
xlabel('-B');
xlim([0,0.1]);
ylim([0,600]);
ylabel('\chi of the linear fitting');
[~,m]=min(Err);
