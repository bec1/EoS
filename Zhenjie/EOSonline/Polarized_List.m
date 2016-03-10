% FileName='\\Elder-pc\j\Elder Backup Raw Images\2016\2016-02\2016-02-23\02-23-2016_21_04_34_top.fits';
%%
addpath('../Library');
warning('off','all');
%%
Folder='/Users/Zhenjie/Data/2016-03-02/';
N=length(list);
Ptlist=[];
Ktlist=[];
ROI1=[215,25,312,402];
ROI2=[209,187,335,243];
for i=1:N
    [Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,~]=EOS_Online( [Folder,list{i},'.fits'],'ROI1',[215,15,312,450],...
    'ROI2',[209,187,335,243],'ShowOutline',0,'TailRange',[50,395],'KappaMode',2,'PolyOrder',10,'VrangeFactor',4,'IfHalf',1,'ShowPlot',0 ,'kmin',0.6,'kmax',0.9,...
    'Fudge',2.3,'BGSubtraction',BGimg);
    Ptlist=[Ptlist;Ptsel];
    Ktlist=[Ktlist;Ktsel];
end
scatter(Ptlist,Ktlist)
xlim([0,6])
hold on
[ KappaTildeP, PTildeP, ~, ~ ] = IdealFermiEOS( 1.1, 4, 1000 );
plot(PTildeP,KappaTildeP);
hold off
%%
PtBinMin=0;
PtBinMax=3;
dPt=0.02;
Ptbin=PtBinMin:dPt:PtBinMax;
Nbin=size(Ptbin,2);
M=length(Ktlist);
KtBinList=cell(1,Nbin);
KtMean=zeros(1,Nbin);
KtStd=zeros(1,Nbin);
for i=1:Nbin
    KtBinList{i}=[];
end

for i=1:M
    K=round((Ptlist(i)-PtBinMin)/dPt+1);
    if K<=Nbin && K>=1
        temp=KtBinList{K};
        KtBinList{K}=[temp,Ktlist(i)];
    end
end

for i=1:Nbin
    KtMean(i)=mean(KtBinList{i});
    KtStd(i)=std(KtBinList{i})/sqrt(length(KtBinList{i}));
    if length(KtBinList{i})<3
        KtStd(i)=nan;
        KtMean(i)=nan;
    end
end
errorbar(Ptbin,KtMean,KtStd)
% scatter(Ptbin,KtMean);
% scatter(Ptlist,Ktlist)
xlim([0,4])
hold on
plot(PTildeP,KappaTildeP);
hold off