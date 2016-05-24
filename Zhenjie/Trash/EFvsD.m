N=size(list,1);
Ef=zeros(N,1);
D=zeros(N,1);
mu=zeros(N,1);
folder='\\Elder-pc\j\Elder Backup Raw Images\2016\2016-02\2016-02-12\';
ROI1=[150,50,400,420];
ROI2=[209,211,332,225];
BG=[35,150,170,340];
X=ROI2(1):ROI2(3);
Y=ROI2(2)+1:ROI2(4)-1;

mli=6*1.6738232*10^(-27);
hbar=1.0545718*10^(-34);
omega=23*2*pi;
pixel=1.5*10^(-6);


for i=1:N
    Image=fitsreadRL([folder,list{i},'.fits']);
    Nimg=AtomNumber( Image,1.44^2,0.215/2,630);
    BGimg=Nimg(BG(2):BG(4),BG(1):BG(3));
    BGimg=BGimg(:);
    Nbg=sum(BGimg)/length(BGimg);
    Nimg=Nimg-Nbg;
    [x1,x2,X1,X2,Yt,p1,p2 ]=CylinderOutline( Nimg,ROI2 );
    x1=round(x1);x2=round(x2);
    h=figure
    imagesc(Nimg);
    hold on
    plot(X1,Y,'r.','MarkerSize',5);
    plot(X2,Y,'r.','MarkerSize',5);
    caxis([0,45]);
    disp(list{i})
%     pause()
    close(h)
    D(i)=mean(X2-X1);
    Yt=ROI1(2):ROI1(4);
    [n,Z] = GetnvsZ( Nimg,x1,x2,Yt,1.5e-6,1);
    h=figure;
    plot(Z,n)
    disp(list{i})
%     pause()
    close(h)
    nF1=max(n);
    kf=(6*pi^2*nF1)^(1/3);
    Ef(i)=hbar^2*kf^2/(2*mli);
    Ptf=TFfit(n,Z,90);
    Rtf=Ptf(3)*pixel;
    mu(i)=0.5*mli*omega^2*Rtf^2;
end
h=hbar*2*pi;
Ef=Ef/h/1000;
mu=mu/h/1000;
