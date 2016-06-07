omega=23.0*2*pi;pixelsize=1.44e-6;  mli=9.988346*10^(-27); hbar= 6.62607/(2*pi)*10^(-34);
hh=hbar*2*pi;
% <<<<<<< HEAD
% filename='02-15-2016_21_04_37_top.fits';
% %folder='\\Elder-pc\j\Elder Backup Raw Images\2016\2016-02\2016-02-15\';
% folder = '/Users/Julian/Dropbox (MIT)/BEC1/Image Data and Cicero Files/Data - Raw Images/2016/2016-02/2016-02-15/';
% addpath('/Users/Julian/Documents/MIT/MatlabPrograms/VirialExpansion/')
% =======
% filename='02-15-2016_23_08_42_top.fits';
% folder='\\Elder-pc\j\Elder Backup Raw Images\2016\2016-02\2016-02-15\';
% >>>>>>> origin/master

ROI1=[200,60,300,380];
ROI2=[200,185,336,270];
BG=[178,380,326,452];

X=ROI2(1):ROI2(3);
Y=ROI2(2):ROI2(4);

Image=fitsread('02-15-2016_21_04_37_top.fits');
Nimg=AtomNumber( Image,1.5^2,0.215/2,630);

BGimg=Nimg(BG(2):BG(4),BG(1):BG(3));
BGimg=BGimg(:);
Nbg=sum(BGimg)/length(BGimg);
Nimg=Nimg-Nbg;
Nimg(isnan(Nimg))=0;
Nimg(Nimg==inf)=0;
Nimg(Nimg==-inf)=0;

[n,z] = GenNvsZ( Nimg,ROI1,ROI2,pixelsize,0,1);
n=1.8371*n;
scatter(z,n)
Ptf=TFfit(n,z,80);
ntf=TFfun(Ptf,z);
scatter(z,n)
hold on
plot(z,ntf)
hold off
z0=Ptf(2);
z=z-z0;

Z=z*pixelsize;
V=1/2*mli*omega^2*Z.^2;
[Vs,I]=sort(V);
ns=n(I);
% ns=smooth(ns);
[P,P0,Pt] = GetPvsV( ns,Vs );
scatter(Vs,Pt)
ylim([0,4])
Kt=GetKappavsV( ns,Vs );
scatter(z,n)
scatter(Vs/hh,ns)
scatter(Vs/hh,Kt)

%filter the data point one the wings and in the center
% Pt((Vs<1e-32))=[];
% Kt((Vs<1e-32))=[];
% Vs(Vs<1e-32)=[];
% Pt((Vs>5e-29))=[];
% Kt((Vs>5e-29))=[];
% Vs(Vs>5e-29)=[];
% scatter(Pt,Kt)
% xlim([0,4]);
% ylim([0,4]);
% [ KappaTilde, PTilde, Z_vec ] = ...
%     VirialUnitarity(  1.95, 4, 1000 , 3 );
% 
% scatter(Pt,Kt)
% xlim([0,4])
% ylim([0,4])
% hold on
% plot(PTilde,KappaTilde)
% hold off
% 
% <<<<<<< HEAD
% VkHz=Vs/(hbar*2*pi)/1000;
% %scatter(VkHz,Pt)
% %scatter(VkHz,Kt)
% %scatter(Vs,Pt)
% =======
% % VkHz=Vs/(hbar*2*pi)/1000;
% % scatter(VkHz,Pt)
% % scatter(VkHz,Kt)
% % scatter(Vs,Pt)
% >>>>>>> origin/master
% % ylim([0,3])