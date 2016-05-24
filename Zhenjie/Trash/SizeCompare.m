folder='\\Elder-pc\j\Elder Backup Raw Images\2016\2016-02\2016-02-12\';
fileReramp='02-12-2016_21_36_15_top.fits';
fileNoReramp='02-12-2016_21_32_42_top.fits';

ROI=[205,164,332,291];
X=ROI(1):ROI(3);
Y=ROI(2)+1:ROI(4)-1;

Image1=fitsreadRL([folder,fileReramp]);
Image2=fitsreadRL([folder,fileNoReramp]);
Nimg1=AtomNumber( Image1,1.5^2,0.215,630);
Nimg2=AtomNumber( Image2,1.5^2,0.215,630);

[x1a,x2a,X1a,X2a,Yta,p1a,p2a ] = CylinderOutline( Nimg1,ROI );
[x1b,x2b,X1b,X2b,Ytb,p1b,p2b ] = CylinderOutline( Nimg2,ROI );
subplot(1,2,1)
imagesc(Nimg1)
hold on
plot(X1a,Y,'r.','MarkerSize',5);
plot(X2a,Y,'r.','MarkerSize',5);
caxis([0 50])
axis equal tight
title('With Reramp')
subplot(1,2,2)
imagesc(Nimg2)
hold on
plot(X1b,Y,'r.','MarkerSize',5);
plot(X2b,Y,'r.','MarkerSize',5);
caxis([0 50])
axis equal tight
title('Without Reramp')


scatter(Y,(X2a-X1a)./(X2b-X1b))