%%
%2016-06-09A Majority
% filelist={'06-10-2016_01_43_06_top';'06-10-2016_01_40_02_top';'06-10-2016_01_35_55_top';'06-10-2016_01_34_10_top';'06-10-2016_01_32_24_top';'06-10-2016_01_30_25_top';'06-10-2016_01_28_16_top';'06-10-2016_01_26_30_top';'06-10-2016_01_24_16_top';'06-10-2016_01_22_08_top';'06-10-2016_01_20_22_top';'06-10-2016_01_18_29_top';'06-10-2016_01_16_43_top';'06-10-2016_01_14_58_top';'06-10-2016_01_10_31_top';'06-10-2016_01_04_57_top';'06-10-2016_01_00_14_top'};
% %2016-06-09A Minority
% filelist={'06-10-2016_01_43_58_top';'06-10-2016_01_42_13_top';'06-10-2016_01_39_09_top';'06-10-2016_01_36_53_top';'06-10-2016_01_35_02_top';'06-10-2016_01_33_17_top';'06-10-2016_01_31_31_top';'06-10-2016_01_29_32_top';'06-10-2016_01_27_23_top';'06-10-2016_01_23_23_top';'06-10-2016_01_21_15_top';'06-10-2016_01_19_29_top';'06-10-2016_01_17_36_top';'06-10-2016_01_15_50_top';'06-10-2016_01_14_05_top';'06-10-2016_01_09_38_top';'06-10-2016_01_07_52_top';'06-10-2016_01_06_06_top';'06-10-2016_01_01_07_top';'06-10-2016_00_59_22_top';'06-10-2016_00_58_29_top';'06-10-2016_00_57_36_top'};
% %2016-06-09B Majority
% filelist={'06-10-2016_00_48_23_top';'06-10-2016_00_46_37_top';'06-10-2016_00_44_52_top';'06-10-2016_00_42_58_top';'06-10-2016_00_41_54_top';'06-10-2016_00_40_08_top';'06-10-2016_00_37_00_top';'06-10-2016_00_34_59_top';'06-10-2016_00_33_13_top';'06-10-2016_00_29_43_top';'06-10-2016_00_27_38_top';'06-10-2016_00_25_52_top';'06-10-2016_00_24_06_top';'06-10-2016_00_22_07_top';'06-10-2016_00_17_41_top'};
%filelist={'06-10-2016_00_47_31_top';'06-10-2016_00_45_45_top';'06-10-2016_00_43_59_top';'06-10-2016_00_41_01_top';'06-10-2016_00_36_07_top';'06-10-2016_00_34_06_top';'06-10-2016_00_30_36_top';'06-10-2016_00_28_50_top';'06-10-2016_00_26_45_top';'06-10-2016_00_24_59_top';'06-10-2016_00_23_14_top';'06-10-2016_00_18_33_top';'06-10-2016_00_16_48_top'};
%filelist={'05-16-2016_19_12_21_top';'05-16-2016_19_10_37_top';'05-16-2016_19_08_51_top';'05-16-2016_19_07_07_top';'05-16-2016_19_05_21_top';'05-16-2016_19_03_37_top';'05-16-2016_19_01_51_top';'05-16-2016_18_57_27_top';'05-16-2016_18_54_42_top';'05-16-2016_18_52_57_top';'05-16-2016_18_48_55_top';'05-16-2016_18_47_10_top';'05-16-2016_18_44_49_top';'05-16-2016_18_43_05_top'};
filelist={'05-16-2016_19_13_13_top';'05-16-2016_19_11_29_top';'05-16-2016_19_06_13_top';'05-16-2016_19_04_29_top';'05-16-2016_18_53_50_top';'05-16-2016_18_48_02_top';'05-16-2016_18_45_42_top'};
folder='/Users/Zhenjie/Data/2016-05-16/';
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
Nsat=330;
%% Get the total atom number for each img;

ROI=[140,25,350,490];
Z=ROI(2):ROI(4);
Z=Z';
zmin=150;zmax=360;
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
tolerance=0.05;
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

save('Data/2016-05-16-Minority.mat','imglistpick','filelistpick','numlistpick');

