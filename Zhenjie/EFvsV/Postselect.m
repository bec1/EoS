%%
filelist={};
folder='/Users/Zhenjie/Data/2016-06-09/';
%%
%Define the physical constant
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
%load all the functions
addpath('../Library');
Nsat=390;
%% Get the total atom number for each img;

ROI=[140,25,350,490];
Z=ROI(2):ROI(4);
Z=Z';
zmin=120;zmax=390;
index=1:length(filelist);
imglist={};
numlist=[];
for i=1:length(filelist)
    tempimg=fitsread([folder,filelist{i},'.fits']);
    imglist=[imglist,tempimg];
    Nimg=AtomNumber(tempimg,pixellength^2,sigma0, Nsat);
    Nimg=Nimg(ROI(2):ROI(4),ROI(1):ROI(3));
    Nz=sum(Nimg,2);
    Nz=TailTailor(Nz,Z,zmin,zmax);
    numlist=[numlist;sum(Nz)];
end
scatter(index,numlist)
ylim([0,1.1*max(numlist)]);
xlabel('Img index');ylabel('Total Atom number');
%%
tolerance=0.1;
minscan=min(numlist);maxscan=max(numlist);
MeanNumlist=linspace(minscan,maxscan,40);
Npick=0*MeanNumlist;

for i=1:length(MeanNumlist)
    mask1=numlist<=(MeanNumlist(i)*(1+tolerance));
    mask2=numlist>=(MeanNumlist(i)*(1-tolerance));
    mask=mask1 & mask2;
    Npick(i)=sum(mask);
end
scatter(MeanNumlist,Npick);

%%
[~,B]=max(Npick);
MeanNum=MeanNumlist(B);
mask1=numlist<=(MeanNum*(1+tolerance));
mask2=numlist>=(MeanNum*(1-tolerance));
mask=mask1 & mask2;

imglistpick=imglist(mask);
filelistpick=filelist(mask);
numlistpick=numlist(mask);
%%

save('Data/2016-06-09-minorityA.mat','imglistpick','filelistpick','numlistpick');