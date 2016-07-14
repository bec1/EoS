%%
addpath('../Library');
warning('off','all');
load('BGimg0223.mat')
list={'02-23-2016_22_56_38_top';'02-23-2016_23_06_00_top';'02-23-2016_23_03_54_top';'02-23-2016_23_01_30_top';'02-23-2016_22_59_12_top';'02-23-2016_22_58_20_top';'02-23-2016_22_57_29_top';'02-23-2016_22_56_38_top';'02-23-2016_22_55_46_top';'02-23-2016_22_54_55_top';'02-23-2016_22_54_04_top';'02-23-2016_22_53_13_top';'02-23-2016_22_52_23_top';'02-23-2016_22_51_32_top';'02-23-2016_22_50_41_top';'02-23-2016_22_49_50_top';'02-23-2016_22_49_00_top';'02-23-2016_22_48_10_top';'02-23-2016_22_47_19_top';'02-23-2016_22_46_29_top';'02-23-2016_22_45_38_top';'02-23-2016_22_41_54_top';'02-23-2016_22_40_49_top';'02-23-2016_22_39_14_top';'02-23-2016_22_38_09_top';'02-23-2016_22_37_04_top';'02-23-2016_22_35_59_top';'02-23-2016_22_33_31_top';'02-23-2016_22_32_29_top';'02-23-2016_22_30_24_top';'02-23-2016_22_28_20_top';'02-23-2016_22_26_43_top';'02-23-2016_22_25_43_top';'02-23-2016_22_24_43_top';'02-23-2016_22_23_43_top';'02-23-2016_22_22_43_top';'02-23-2016_22_21_43_top';'02-23-2016_22_20_03_top';'02-23-2016_22_19_07_top';'02-23-2016_22_18_11_top';'02-23-2016_22_16_20_top';'02-23-2016_22_15_24_top';'02-23-2016_22_14_29_top';'02-23-2016_22_13_34_top';'02-23-2016_22_08_07_top';'02-23-2016_22_07_14_top';'02-23-2016_22_06_20_top';'02-23-2016_22_05_27_top';'02-23-2016_22_04_33_top';'02-23-2016_22_03_39_top';'02-23-2016_22_02_47_top';'02-23-2016_22_01_54_top';'02-23-2016_22_01_02_top';'02-23-2016_22_00_09_top';'02-23-2016_21_59_16_top';'02-23-2016_21_58_24_top';'02-23-2016_21_57_32_top';'02-23-2016_21_56_40_top';'02-23-2016_21_55_49_top';'02-23-2016_21_54_05_top';'02-23-2016_21_53_14_top';'02-23-2016_21_52_16_top';'02-23-2016_21_50_19_top';'02-23-2016_21_49_21_top';'02-23-2016_21_46_18_top';'02-23-2016_21_45_21_top';'02-23-2016_21_44_24_top';'02-23-2016_21_43_27_top';'02-23-2016_21_40_02_top';'02-23-2016_21_37_14_top';'02-23-2016_21_36_20_top';'02-23-2016_21_35_26_top';'02-23-2016_21_34_32_top';'02-23-2016_21_33_37_top';'02-23-2016_21_32_28_top';'02-23-2016_21_31_32_top';'02-23-2016_21_30_36_top';'02-23-2016_21_29_39_top';'02-23-2016_21_28_43_top';'02-23-2016_21_27_47_top';'02-23-2016_21_20_00_top';'02-23-2016_21_19_06_top';'02-23-2016_21_18_13_top';'02-23-2016_21_17_20_top';'02-23-2016_21_16_27_top';'02-23-2016_21_15_34_top';'02-23-2016_21_13_39_top';'02-23-2016_21_12_47_top';'02-23-2016_21_11_52_top';'02-23-2016_21_11_01_top';'02-23-2016_21_09_31_top';'02-23-2016_21_08_40_top';'02-23-2016_21_07_13_top';'02-23-2016_21_06_22_top';'02-23-2016_21_05_24_top';'02-23-2016_21_04_34_top';'02-23-2016_21_03_31_top';'02-23-2016_21_02_41_top';'02-23-2016_21_01_30_top';'02-23-2016_21_00_38_top';'02-23-2016_20_59_31_top';'02-23-2016_20_58_38_top';'02-23-2016_20_57_36_top';'02-23-2016_20_56_44_top';'02-23-2016_20_55_38_top';'02-23-2016_20_54_43_top';'02-23-2016_20_53_43_top';'02-23-2016_20_52_47_top'};
%%
% FileName='\\Elder-pc\j\Elder Backup Raw Images\2016\2016-02\2016-02-23\02-23-2016_21_04_34_top.fits';
warning('off','all')
Folder='/Users/Zhenjie/Data/2016-02-23/';
N=length(list);
Ptlist=[];
Ktlist=[];
ROI1=[215,25,312,402];
ROI2=[209,187,335,243];
for i=1:N
    [Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,~]=EOS_Online( [Folder,list{i},'.fits'],'ROI1',[215,25,312,402],...
    'ROI2',[209,187,335,243],'ShowOutline',0,'TailRange',[85,325],'KappaMode',1,'PolyOrder',2,...
    'VrangeFactor',5,'IfHalf',0,'kmax',1.1,'kmin',0.25,'Points',5,...
    'Fudge',2.62,'smooth',1,'CutOff',inf,'ShowPlot',0,'ShowOutline',0,'BGSubtraction',BGimg,...
    'SelectByPortion',0,'Portion',0.1,'IfTailTailor',1,'IfFitExpTail',0,'ExpTailPortion',0.06,...
    'SM',4,'IfBin',0,'BinGridSize',250,'IfSuperSampling',0);
%     [Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,~]=EOS_Online( [Folder,list{i},'.fits'],'ROI1',[215,25,312,402],...
%     'ROI2',[209,187,335,243],'TailRange',[85,325],'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,'kmax',1.1,'kmin',0.1,'Points',3,...
%     'Fudge',2.62,'smooth',0,'CutOff',inf,'ShowPlot',0,'ShowOutline',0,'BGSubtraction',BGimg);

    Ptlist=[Ptlist;Ptsel];
    Ktlist=[Ktlist;Ktsel];
    disp(i);
end
%%
scatter(Ptlist,Ktlist,'r.')
xlim([0,6])
ylim([-2,4])
hold on
[ KappaTilde, PTilde, ~, ~ ] = VirialUnitarity(  );
plot(PTilde,KappaTilde,'LineWidth',3,'color','b');
hold off
%%
[PtlistF,KtlistF]=ClusterFilter(Ptlist,Ktlist,0.1,0.1,2);
scatter(PtlistF,KtlistF,'r.')
xlim([0,6])
hold on
[ KappaTilde, PTilde, ~, ~ ] = VirialUnitarity(  );
plot(PTilde,KappaTilde,'color','b','linewidth',3);
xlabel('P/P_0');ylabel('\kappa/\kappa_0');
hold off

%%
PtBinMin=0.3;
PtBinMax=5;
N=100;
thres=6;
PtGrid=logspace(log(PtBinMin)/log(10),log(PtBinMax)/log(10),N);
[ PtMean,KtMean,PtStd,KtStd ] = BinGrid( PtlistF,KtlistF,PtGrid,thres );
%%
errorbar(PtMean,KtMean,KtStd,'MarkerFaceColor',[1 1 0],'Marker','diamond',...
    'LineStyle','none',...
    'Color',[1 0 0],'DisplayName','EoS')
% scatter(Ptbin,KtMean);
% scatter(Ptlist,Ktlist)
xlim([0,7])
hold on
[ KappaTilde, PTilde, ~, ~ ] = VirialUnitarity(  );
plot(PTilde,KappaTilde,'color','b','linewidth',3,'DisplayName','Virial Expansion');
legend('show')
xlabel('P/P_0');ylabel('\kappa/\kappa_0');
hold off

%%
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
Nsat=330; %PI Camera
[ KappaTildeT_Pol, PTildeT_Pol,TTildeT_Pol] = IdealFermiEOS(  );
Xdash=0.1:0.05:6;
Ydash=1./Xdash;
[ KappaTildeT_U, PTildeT_U, TTildeT_U, ~, ~] = ...
    VirialUnitarity( );

%%

figure1=figure('Name','Figure');
axes1 = axes;

errorbar1derr_Z(PtMean,KtMean,KtStd,'Markersize',5,'MarkerFaceColor',[1 1 0],'Marker','.','LineStyle','none','Color',[1 0 0],'ErrLineWidth',0.5);

hold on
p2=plot(Xdash,Ydash,'k--');
set(p2,'DisplayName','KappaTilde*PTilde=1');
p3=plot(PTildeT_U,KappaTildeT_U);
set(p3,'DisplayName','Virial Expansion 3rd order','LineWidth',1.5,...
    'Color',[0 0.447058826684952 0.74117648601532]);
%p4=scatter(Ptbin_Pol,KtMean_Pol,'k*');
%set(p4,'DisplayName','Simulated Polarized Fermi Gas EoS')
%p5=plot(PTildeT_Pol,KappaTildeT_Pol,'linewidth',3);
%set(p5,'DisplayName','Ideal Polarized Fermi Gas EoS')
xlim([0,4]);
ylim([0,4]);
xlabel('P/P_0');ylabel('\kappa/\kappa_0');
set(axes1,'XTick',[0 1 2 3 4],'YTick',[0 1 2 3 4]);
set(axes1,'Units','inches','Position',[2 2 2.8 2.4]);
hold off

%%
PtU=PtMean;
KtU=KtMean;
% the cutoff value for the pressure.
Ptcutoff=4;


KtU(PtU>Ptcutoff)=[];
PtU(PtU>Ptcutoff)=[];
PtU(isnan(KtU))=[];
KtU(isnan(KtU))=[];

Ttcutoff=interp1(PTildeT_U,TTildeT_U,max(PtU));
figure1=figure('Name','Figure');
axes1 = axes;
TtU=GetTTilde(PtU,KtU,Ttcutoff);
p1=scatter(TtU,KtU,'DisplayName','Experiment Data Unitary');
hold on
pbaspect([1 0.5 1])
plot(TTildeT_U,KappaTildeT_U,'r','linewidth',3,'DisplayName','Virial Expansion 3rd order');
xlabel('T/T_F');
ylabel('\kappa/\kappa_0')
title('\kappa/\kappa_0 vs T/T_F');
xlim([0,1.5])
p3=line([0.167,0.167],[0,3],'linewidth',1,'DisplayName','Tc=0.167');
%scatter(Tt_pol,KtMean_Pol,'DisplayName','Simulated Polarize Gas')
%plot(TTildeT_Pol,KappaTildeT_Pol,'DisplayName','Ideal Polarize Gas','linewidth',3)
%legend('show');
hold off

%%
%%Try to get C_V with P,Kappa and T
Cvt_PKTU = GetCvTilde( PtU,KtU,TtU );
Cvt_PKTU = Cvt_PKTU;

figure1=figure('Name','Figure');
axes1 = axes;
plot(TtU,Cvt_PKTU,'.','color',[0 0.45 0.74],'markersize',20);
hold on
line([0.167,0.167],[-1,3],'color','k','linewidth',3)
CvTildeT_U=GetCvTilde( PTildeT_U,KappaTildeT_U,TTildeT_U );
plot(TTildeT_U,CvTildeT_U,'DisplayName','Virial Expansion','linewidth',1,'color',[0.85,0.33,0.1]);
pbaspect([1 0.5 1])
ylim([0,2.5]);xlim([0,1.5]);
xlabel('T/T_F');
ylabel('C_V/(k_B N)');
%scatter(Tt_pol,CvTilde_Sim_Pol,'k*','DisplayName','Simulated Polarized Gas');
%plot(TTildeT,CvTildeT_Pol,'DisplayName','Ideal Polarized Gas','LineWidth',3);
%title('C_V get from PTilde,kappaTilde,TTilde');
%line([0.167,0.167],[0,3],'linewidth',1,'DisplayName','Tc=0.167');
%legend('show');
hold off
set(axes1,'XTick',[0 0.5 1 1.5],'YTick',[0 1 2]);
set(axes1,'Units');
savefig(figure1,'Cv.fig');
print(figure1,'Cv','-dpdf');