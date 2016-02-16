omega=23.9*2*pi;pixelsize=1.44e-6;

filename='02-15-2016_21_04_37_top.fits';
folder='\\Elder-pc\j\Elder Backup Raw Images\2016\2016-02\2016-02-15\';

ROI1=[200,60,300,380];
ROI2=[200,185,336,270];
BG=[178,380,326,452];

X=ROI2(1):ROI2(3);
Y=ROI2(2):ROI2(4);

Image=fitsreadRL([folder,filename]);
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
scatter(Vs,ns)
scatter(Vs,Kt)

%filter the data point one the wings and in the center
Pt((Vs<1e-32))=[];
Kt((Vs<1e-32))=[];
Vs(Vs<1e-32)=[];
Pt((Vs>1.25e-30))=[];
Kt((Vs>1.25e-30))=[];
Vs(Vs>1.25e-30)=[];

scatter(Pt,Kt)
xlim([0,4])
ylim([0,4])

VkHz=Vs/(hbar*2*pi)/1000;
scatter(VkHz,Pt)
scatter(VkHz,Kt)
% scatter(Vs,Pt)
% ylim([0,3])