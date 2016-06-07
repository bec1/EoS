%%
addpath('../Library');
load('BGimg0223');
%Define the physical constant
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
warning('off','all');
[ KappaTildeT_U, PTildeT_U, TTildeT_U, ~, ~] = VirialUnitarity( );

filefolder_Unitary='/Users/Zhenjie/Data/2016-02-23/';

%%
file1='02-23-2016_21_04_34_top';
[Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,EF]=EOS_Online( [filefolder_Unitary,file1,'.fits'],'ROI1',[215,25,312,402],...
    'ROI2',[209,187,335,243],'ShowOutline',0,'TailRange',[85,325],'KappaMode',5,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',1.1,'kmin',0.1,'Points',20,...
    'Fudge',2.8,'smooth',0,'CutOff',inf,'ShowPlot',1,'ShowOutline',0,'BGSubtraction',BGimg,'SelectByPortion',0,'Portion',0.1,'SM',4,...
    'IfTailTailor',1,'IfFitExpTail',1,'ExpTailPortion',0.06,'IfBin',1,'BinGridSize',100);
%%
%%
filefolder_Unitary='/Users/Zhenjie/Data/2016-02-23/';
fileUList={'02-23-2016_21_07_13_top';'02-23-2016_21_06_22_top';'02-23-2016_21_05_24_top';'02-23-2016_21_04_34_top';'02-23-2016_21_03_31_top';'02-23-2016_21_02_41_top'};
VsortUList={};
EFUList={};
for i=1:length(fileUList)
    [~,~,~,VsortS2,~,~,~,EFS2]=EOS_Online( [filefolder_Unitary,fileUList{i},'.fits'] ,'ROI1',[215,25,312,402],...
    'ROI2',[209,187,335,243],'TailRange',[85,350],'ShowOutline',0,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',0.9,'kmin',0.15,...
    'Fudge',2.8,'BGSubtraction',0,'IfFitExpTail',0,'Nsat',330,'ShowPlot',0,'BGSubtraction',BGimg,'CutOff',inf,'IfHalf',0);
    VsortUList=[VsortUList;VsortS2];
    EFUList=[EFUList;EFS2];
end
%%
plot(VsortUList{1}/hh,EFUList{1}/hh,'r.');
hold on
plot(VsortUList{5}/hh,EFUList{5}/hh,'b.');
plot(VsortUList{6}/hh,EFUList{6}/hh,'g.');
hold off

%%
VsortU=[];
EFU=[];

for i=1:length(fileUList)
    VsortU=[VsortU;VsortUList{i}];
    EFU=[EFU;EFUList{i}];
end
VsortU=VsortU/hh;
EFU=EFU/hh;
%%
plot(VsortU,EFU,'r.');
xlabel('V (Hz)');ylabel('EF (Hz)');
title('Majority, EF vs V');

%%
Nbin=80;
%Vgrid=linspace(0,sqrt(max(VsortS1)),Nbin+1).^2;
Vgrid=linspace(0,0.6e4,Nbin+1);

[VUPlot,EFUPlot,VUPlotErr,EFUPlotErr]=BinGrid(VsortU,EFU,Vgrid,2);

mask=isnan(EFUPlot);
VUPlot(mask)=[];
EFUPlot(mask)=[];
VUPlotErr(mask)=[];
EFUPlotErr(mask)=[];

figure1 = figure;
axes1 = axes('Parent',figure1);
plot(VUPlot/1e3,EFUPlot/1e3,'r','linewidth',2)
xlabel('V (kHz)');ylabel('EF (kHz)');
title('Unitary, EF vs V, Binned');
% Set the remaining axes properties
ylim([-0.5,8]);xlim([0,6]);
set(axes1,'XTick',[0 2 4 6],'YTick',[0 2 4 6 8]);
savefig(figure1,'UnitaryEFvsV.fig');
print(figure1,'UnitaryEFvsV','-dpdf');

%%
%%
Nbin=180;
%Vgrid=linspace(0,sqrt(max(VsortS1)),Nbin+1).^2;
Vgrid=linspace(0,1.3e4,Nbin+1);
[VUBin,EFUBin,VUErr,EFUErr]=BinGrid(VsortU,EFU,Vgrid,2);

mask=isnan(EFUBin);
VUBin(mask)=[];
EFUBin(mask)=[];
VUErr(mask)=[];
EFUErr(mask)=[];

errorbar(VUBin,EFUBin,EFUErr,'r.');
%%
[kappaUT,kappaUTerr] = FiniteD( VUBin,VUErr,EFUBin,EFUErr,4);
kappaUT=-kappaUT;
errorbar(VUBin,kappaUT,kappaUTerr,'r.');

xlim([0,12000]);ylim([-0.2,3.5]);
xlabel('V (Hz)');ylabel('KappaTilde');
title('Majority, after averaging');
xlim([0,12000])

%%

figure1 = figure;
axes1 = axes('Parent',figure1);
errorbar1derr_Z(VUBin/1e3,kappaUT,kappaUTerr,'LineStyle','none','Markersize',15,'Color','b');
hold on
line([800,800],[-0.2e1,1e1])
hold off
xlim([0,12]);ylim([-0.2,3.5]);
xlabel('V (Hz)');ylabel('KappaTilde');
set(axes1,'XTick',[0 4 8 12],'YTick',[0 1 2 3]);
savefig(figure1,'UnitaryKappavsV.fig');
print(figure1,'UnitaryKappavsV','-dpdf');