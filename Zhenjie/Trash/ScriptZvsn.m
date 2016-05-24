filename='02-12-2016_21_06_29_top.fits';
folder='\\Elder-pc\j\Elder Backup Raw Images\2016\2016-02\2016-02-12\';

ROI1=[150,50,400,420];
ROI2=[212,160,337,260];
BG=[35,150,170,340];

X=ROI2(1):ROI2(3);
Y=ROI2(2):ROI2(4);

Image=fitsreadRL([folder,filename]);
Nimg=AtomNumber( Image,1.5^2,0.215/2,630);

BGimg=Nimg(BG(2):BG(4),BG(1):BG(3));
BGimg=BGimg(:);
Nbg=sum(BGimg)/length(BGimg);
Nimg=Nimg-Nbg;

[x1,x2,~,~,Yt,p1,p2 ]=CylinderOutline( Nimg,ROI2 );
x1=round(x1);x2=round(x2);
h=figure
imagesc(Nimg);
hold on
plot(x1,Yt,'r.','MarkerSize',5);
plot(x2,Yt,'r.','MarkerSize',5);
pause()
close(h)
gaussian = @(p,xdata)p(1)*exp(-(xdata-p(3)).^2/(2*p(4)^2))+p(2); 

Yt=ROI1(2):ROI1(4);
N=length(Yt);
[ n,Z ] = GetnvsZ( Nimg,x1,x2,Yt,1.5e-6,1);
Z0=CMass1d( n,Z );
Pg=fit1dgaussian(n,Z,Z0);
Ptf=TFfit(n,Z,Pg(4));
ng=gaussian(Pg,Z);
ntf=TFfun(Ptf,Z);
scatter(Z,n)
hold on
plot(Z,ng,Z,ntf)
hold off
z0=Ptf(2)