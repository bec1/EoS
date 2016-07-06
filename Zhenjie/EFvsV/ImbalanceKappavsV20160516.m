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
%% load the majority Data
load('Data/2016-05-16-Majority.mat');
ImglistMajority=imglistpick;
% [~,~,~,VsortS1,~,~,~,EFS1]=EOS_Online( ImglistMajority{2} ,'ROI1',[157,25,390,490],...
%     'ROI2',[157,125,390,380],'TailRange',[60,430],'ShowOutline',1,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.05,...
%     'Fudge',2.8,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',330,'ShowPlot',1,'CutOff',inf,'IfHalf',0);
[~,~,~,VsortS1,~,~,~,EFS1]=EOS_Online( ImglistMajority{9} ,'ROI1',[157,50,390,450],...
    'ROI2',[157,130,390,320],'TailRange',[90,410],'ShowOutline',1,'KappaMode',5,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.05,...
    'Fudge',2.8,'BGSubtraction',0,'IfFitExpTail',1,'IfBin',1,'SM',4,'Nsat',330,'ShowPlot',1,'CutOff',inf,'IfHalf',0);

%% Get the profile for all of them
VsortS1List={};
EFS1List={};
for i=1:length(ImglistMajority)
%     [~,~,~,VsortS1,~,~,~,EFS1]=EOS_Online( ImglistMajority{i},'ROI1',[157,25,390,490],...
%      'ROI2',[157,125,390,380],'TailRange',[60,430],'ShowOutline',0,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.15,...
%     'Fudge',2.8,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',330,'ShowPlot',0,'CutOff',inf,'IfHalf',0);
    [~,~,~,VsortS1,~,~,~,EFS1]=EOS_Online( ImglistMajority{i} ,'ROI1',[157,50,390,450],...
     'ROI2',[157,150,390,350],'TailRange',[90,410],'ShowOutline',0,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.15,...
    'Fudge',2.8,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',330,'ShowPlot',0,'CutOff',inf,'IfHalf',0);
    VsortS1List=[VsortS1List;VsortS1];
    EFS1List=[EFS1List;EFS1];
end
%% plot some of the img
plot(VsortS1List{2}/hh,EFS1List{2}/hh,'r.');
hold on
plot(VsortS1List{5}/hh,EFS1List{5}/hh,'b.');
plot(VsortS1List{7}/hh,EFS1List{7}/hh,'g.');
hold off
%% Stack all the data points together
VsortS1=[];
EFS1=[];

for i=1:length(ImglistMajority)
    VsortS1=[VsortS1;VsortS1List{i}];
    EFS1=[EFS1;EFS1List{i}];
end
VsortS1=VsortS1/hh;
EFS1=EFS1/hh;

plot(VsortS1,EFS1,'r.');
xlabel('V (Hz)');ylabel('EF (Hz)');
title('Majority, EF vs V');
%% Bining
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
ylim([0,1000]);
T=mean(TSample)
ylabel('k_B T (Hz)');xlabel('V(Hz)');
title('Temperature get from P/P_0');


%% Switch to Minority
load('Data/2016-05-16-Minority.mat');
ImglistMinority=imglistpick;
% [~,~,~,VsortS1,~,~,~,EFS1]=EOS_Online( ImglistMinority{1} ,'ROI1',[157,25,390,490],...
%     'ROI2',[157,200,390,320],'TailRange',[90,410],'ShowOutline',1,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.05,...
%     'Fudge',2.6,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',390,'ShowPlot',1,'CutOff',inf,'IfHalf',0);
%% Get the profile for all of Minority
VsortS2List={};
EFS2List={};
for i=1:length(ImglistMinority)
    [~,~,~,VsortS2,~,~,~,EFS2]=EOS_Online(ImglistMinority{i},'ROI1',[157,25,390,490],...
     'ROI2',[157,210,390,280],'TailRange',[150,360],'ShowOutline',0,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.15,...
    'Fudge',2.8,'BGSubtraction',0,'IfFitExpTail',1,'Nsat',330,'ShowPlot',0,'CutOff',inf,'IfHalf',0);
    VsortS2List=[VsortS2List;VsortS2];
    EFS2List=[EFS2List;EFS2];
end
%% plot some of them
plot(VsortS2List{1}/hh,EFS2List{1}/hh,'r.','markersize',10);
hold on
plot(VsortS2List{2}/hh,EFS2List{2}/hh,'b.','markersize',10);
plot(VsortS2List{3}/hh,EFS2List{3}/hh,'g.','markersize',10);
xlim([0,6000]);xlabel('V (Hz) Unshifted');ylabel('E_F(Hz)');
title('Minority unbinned');
hold off
%% Stack all the data toghether
VsortS2=[];
EFS2=[];

for i=1:length(ImglistMinority)
    VsortS2=[VsortS2;VsortS2List{i}];
    EFS2=[EFS2;EFS2List{i}];
end
VsortS2=VsortS2/hh;
EFS2=EFS2/hh;
plot(VsortS2,EFS2,'r.');
xlabel('V (Hz)');ylabel('EF (Hz)');
title('Put Several images together');
%% Bin the Minority profiles
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
%% Get the modified potential for minority
EFS1grid2=interp1(VS1Bin,EFS1Bin,VS2Bin,'spline','extrap');
VmS2=VS2Bin-0.615*EFS1grid2;

plot(VmS2,EFS2Bin,'r.');
xlabel('V modified(Hz)');ylabel('E_F (Hz)');
title('Minority, potential modified by the majority')
%% Get the kappa/kappa0 for the minority
[kappa2T,kappa2Terr] = FiniteD( VmS2,0*VmS2,EFS2Bin,EFS2Err,3 );
kappa2T=-kappa2T;
errorbar(VS2Bin,kappa2T,kappa2Terr,'r.');
xlim([0,5000]);
xlabel('V (Hz)');ylabel('KappaTilde');
title('Minority, after averaging');
%%

errorbar(VmS2,kappa2T,kappa2Terr,'r.');
xlim([min(VmS2),3000]);
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
Nbin=140;
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
fittingrange=-3000;
for i=1:length(VmList)
    Vm=VmList{i};
    EF=EFS2List{i}/hh;
    mask=Vm<fittingrange;
    X=Vm(mask);
    Y=EF(mask);
    P=polyfit(X,Y,1);
    Slopelist=[Slopelist,-P(1)];
end
effmass=mean(Slopelist)
effmassErr=std(Slopelist)/sqrt(length(Slopelist)-1)
% effmassErr=std(Slopelist)
(max(EFS2Bin)/max(EFS1Bin))^1.5
%%
errorbar(VS2Bin,kappa2T,kappa2Terr,'r.');
xlim([0,5000]);
xlabel('V (Hz)');ylabel('KappaTilde');
hold on
line([0,5000],[effmass,effmass]);
hold off
title('Minority, after averaging');
%%
TTildeMinority=T./EFS2Bin;
scatter(TTildeMinority,kappa2T);
xlim([0,2]);
%% only keep the data that T/T_F<0.5;
P=EFS2Bin.^(3/2)./(EFS2Bin.^(3/2)+EFS1grid2.^(3/2));
mask1=TTildeMinority>0;mask2=TTildeMinority<0.5;
mask=mask1&mask2;
EFS2pick=EFS2Bin(mask);
kappa2Tpick=kappa2T(mask);
TTilde2pick=TTildeMinority(mask);
Ppick=P(mask);

% throw away first 4 data points
EFS2pick=EFS2pick(5:end);
kappa2Tpick=kappa2Tpick(5:end);
TTilde2pick=TTilde2pick(5:end);
Ppick=Ppick(5:end);

save('2016-05-16-Processed.mat','Ppick','TTilde2pick','kappa2Tpick','EFS2pick');