%%
load('../Library');
list={};
var=[];
Nsat=315;
pixelsize=1.44^2;
sigma0=0.215/2;
%%
folder='';
AveImgList={};
Varlist=[];
while length(list)>0
    var_sel=var(1);
    list_sel=list(var==var_sel);
    Nt=length(list_sel);
    Nimgtemp=cell(Nt,1);
    for i=1:Nt
        temp=fitsread([folder,list_sel{i},'.fits']);
        Nimgtemp{i}=AtomNumber(temp,pixelsize,sigma0,Nsat);
    end
    AveImglist=[AveImglist;AverageImg(Nimgtemp)];
end