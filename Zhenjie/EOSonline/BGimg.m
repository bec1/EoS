%%
%Prepare the background subtracktion
% BGlist={'03-03-2016_01_58_48_top';'03-03-2016_01_57_56_top';'03-03-2016_01_57_03_top';'03-02-2016_23_43_47_top'};
% folder='/Users/Zhenjie/Data/2016-03-02/';

BGlist={}
folder='/Users/Zhenjie/Data/2016-02-23/';
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
Nsat=330; %P63I Camera
addpath('../Library');
warning('off','all');
%%
N=length(BGlist);
Nimg=cell(N,1);
Nsum=0;
for i=1:N
    img=fitsread([folder,BGlist{i},'.fits']);
    Nimg{i}=AtomNumber(img,pixellength^2,sigma0, Nsat);
    Nsum=Nsum+Nimg{i};
end

BGimg=Nsum/N;
