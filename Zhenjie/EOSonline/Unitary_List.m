%%
addpath('../Library');
warning('off','all');
load('BGimg0223.mat');
load('MarkEoS');
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
    'ROI2',[209,187,335,243],'ShowOutline',0,'TailRange',[65,350],'KappaMode',2,'PolyOrder',10,...
    'VrangeFactor',5,'IfHalf',0,'kmax',0.7,'kmin',0.2,'Points',1,...
    'Fudge',2.62,'smooth',1,'CutOff',inf,'ShowPlot',0,'ShowOutline',0,'BGSubtraction',BGimg,...
    'SelectByPortion',0,'Portion',0.1,'IfTailTailor',1,'IfFitExpTail',0,'ExpTailPortion',0.06,...
    'SM',4,'IfBin',1,'BinGridSize',150,'IfSuperSampling',0);
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
plot(PTildeMark,KappaTildeMark,'k')
hold off
%%
[PtlistF,KtlistF]=ClusterFilter(Ptlist,Ktlist,0.1,0.1,2);
scatter(PtlistF,KtlistF,'r.')
xlim([0,6])
hold on
[ KappaTilde, PTilde, ~, ~ ] = VirialUnitarity(  );
plot(PTilde,KappaTilde,'color','b','linewidth',3);
xlabel('P/P_0');ylabel('\kappa/\kappa_0');
plot(PTildeMark,KappaTildeMark,'k')
hold off
% %%
% PtBinMin=0.3;
% PtBinMax=7;
% dPt=0.02;
% Ptbin=PtBinMin:dPt:PtBinMax;
% Nbin=size(Ptbin,2);
% M=length(KtlistF);
% KtBinList=cell(1,Nbin);
% KtMean=zeros(1,Nbin);
% KtStd=zeros(1,Nbin);
% for i=1:Nbin
%     KtBinList{i}=[];
% end
% 
% for i=1:M
%     K=round((PtlistF(i)-PtBinMin)/dPt+1);
%     if K<=Nbin && K>=1
%         temp=KtBinList{K};
%         KtBinList{K}=[temp,KtlistF(i)];
%     end
% end
% 
% for i=1:Nbin
%     KtMean(i)=mean(KtBinList{i});
%     KtStd(i)=std(KtBinList{i})/sqrt(length(KtBinList{i}));
%     if length(KtBinList{i})<3
%         KtMean(i)=NaN;
%         KtStd(i)=NaN;
%     end
% end
% %%
% errorbar(Ptbin,KtMean,KtStd,'MarkerFaceColor',[1 1 0],'Marker','diamond',...
%     'LineStyle','none',...
%     'Color',[1 0 0],'DisplayName','EoS')
% % scatter(Ptbin,KtMean);
% % scatter(Ptlist,Ktlist)
% xlim([0,4])
% hold on
% [ KappaTilde, PTilde, ~, ~ ] = VirialUnitarity(  );
% plot(PTilde,KappaTilde,'color','b','linewidth',3,'DisplayName','Virial Expansion');
% legend('show')
% xlabel('P/P_0');ylabel('\kappa/\kappa_0');
% plot(PTildeMark,KappaTildeMark,'k')
% hold off


%%
PtBinMin=0.3;
PtBinMax=5;
N=100;
thres=3;
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
plot(PTildeMark,KappaTildeMark,'k')
hold off

%%
% %Try bin with Kt in high T
% Ks=1.5
% Mark1=KtlistF>Ks;
% Mark2=KtlistF<=Ks;
% PtBinMin=0.3;
% PtBinMax=5;
% N=100;
% thres=3;
% PtGrid=logspace(log(PtBinMin)/log(10),log(PtBinMax)/log(10),N);
% [ PtMean1,KtMean1,PtStd1,KtStd1 ] = BinGrid( PtlistF(Mark1),KtlistF(Mark1),PtGrid,10);
% KtGrid=linspace(0.3,Ks+1,40);
% [ KtMean2,PtInvMean2,KtStd1,PtInvStd2 ] = BinGrid( KtlistF(Mark2),1./PtlistF(Mark2),KtGrid,10);
% PtMean2=1./PtInvMean2;
% 
% %%
% scatter(PtMean1,KtMean1);
% % scatter(Ptbin,KtMean);
% % scatter(Ptlist,Ktlist)
% xlim([0,7])
% hold on
% scatter(PtMean2,KtMean2);
% [ KappaTilde, PTilde, ~, ~ ] = VirialUnitarity(  );
% plot(PTilde,KappaTilde,'color','b','linewidth',3,'DisplayName','Virial Expansion');
% legend('show')
% xlabel('P/P_0');ylabel('\kappa/\kappa_0');
% hold off
% %%
% x = 1:10;
% xe = 0.5*ones(size(x));
% y = sin(x);
% ye = std(y)*ones(size(x));
% H=errorbarxy(x,y,xe,ye,{'ko-', 'b', 'r'});