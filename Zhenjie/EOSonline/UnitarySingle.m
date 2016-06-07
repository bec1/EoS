%%
addpath('../Library');
load('BGimg0223');
warning('off','all');
%%
filename='/Users/Zhenjie/Data/2016-01-04/01-05-2016_00_17_37_top.fits';
% [Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,EF,P]=EOS_Online( filename ,'ROI1',[215,25,312,402],...
%     'ROI2',[209,187,335,243],'ShowOutline',1,'TailRange',[85,325],'KappaMode',2,'PolyOrder',10,'Points',2,'VrangeFactor',5,'IfHalf',0,...
%     'CutOff',inf,'kmax',1.1,'kmin',0.15,'BGSubtraction',BGimg,'ShowTailor',1,'SelectByPortion',1,...
%     'IfTailTailor',1,'IfFitExpTail',1,'SM',2,'IfBin',0,'BinGridSize',80,'IfSuperSampling',0,'Fudge',2.7,'Nsat',inf);
[Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,~]=EOS_Online( filename,'ROI1',[215,25,312,402],...
    'ROI2',[209,187,335,243],'ShowOutline',1,'TailRange',[85,350],'KappaMode',2,'PolyOrder',10,...
    'VrangeFactor',5,'IfHalf',0,'kmax',1.1,'kmin',0.3,'Points',10,...
    'Fudge',2.0,'smooth',0,'CutOff',inf,'ShowPlot',1,...
    'SelectByPortion',0,'Portion',0.1,'IfTailTailor',1,'IfFitExpTail',0,'ExpTailPortion',0.06,...
    'SM',3,'IfBin',0,'BinGridSize',120,'IfSuperSampling',0,'Nsat',155);
d=figure();
scatter(Ptsel,Ktsel);
hold on
xlim([0,6])
[ KappaTilde, PTilde, ~, ~ ] = VirialUnitarity();
ylim([0,4])
plot(PTilde,KappaTilde);
hold off
%%
funfit=EF./exp(-3e29*Vsort);
p=polyfit(Vsort,funfit,11);
fun=polyval(p,Vsort).*exp(-3e29*Vsort);
plot(Vsort,EF,'r.');
hold on
plot(Vsort,fun);
hold off
%%
scatter(Pt,Kt);
hold on
xlim([0,6])
[ KappaTilde, PTilde, ~, ~ ] = VirialUnitarity(  2, 7,2000 , 3 );
ylim([0,4])
plot(PTilde,KappaTilde);
hold off
%%
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
%%
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2

load('PTildevsTTildeTable');
scatter(Zsort,nsort);
scatter(Zsort,Pt)
ylim([0,5])
Ptrap=Pt(abs(Zsort)<1.3e-4);
ntrap=nsort(abs(Zsort)<1.3e-4);
Ztrap=Zsort(abs(Zsort)<1.3e-4);
ntrap(abs(Ptrap)>3)=[];
Ztrap(abs(Ptrap)>3)=[];
Ptrap(abs(Ptrap)>3)=[];
scatter(Ztrap,Ptrap);
ylim([0,5])
TTildetrap=interp1(PtTable,TtTable,Ptrap);
EFtrap=hbar^2/(2*mli)*(6*pi^2*ntrap).^(2/3);

Ttrap=TTildetrap.*EFtrap;
scatter(Ztrap,TTildetrap)
xlabel('Z(um)');
ylabel('T/T_F');
scatter(Ztrap,Ttrap/hh)
ylim([0,1000]);
xlabel('Z(um)');ylabel('k_BT(Hz)')
%%
addpath('/Users/Zhenjie/Github/Matlab-Functions-Library/Final')
OUTP = LoSReconstructionTop('02-23-2016_21_11_01_top','plot',{1});
map=OUTP.od_r;
imagesc(map)
caxis([0,0.03])
map(map<0)=0;
TTildeMap=0.1*0.015^(2/3)./(map.^(2/3));

TTildeMap(map==0)=nan;
TTildeMap(1:40,:)=nan;
TTildeMap(290:351,:)=nan;
imagesc(TTildeMap);
colormap('jet')
caxis([0.1,0.5])
h=colorbar();
ylabel(h,'T/T_F')