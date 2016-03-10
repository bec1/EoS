%%
%Prepare the background subtracktion
BGlist={};
folder='/Users/Zhenjie/Data/2016-03-02/';
%%
N=length(BGlist);
Nimg=cell(N,1);
Nsum=0;
for i=1:N
    img=fitsread([folder,BGlist{i},'.fits']);
    Nimg{i}=AtomNumber(img,1.44^2,0.215/2,315);
    Nsum=Nsum+Nimg{i};
end

BGimg=Nsum/N;
