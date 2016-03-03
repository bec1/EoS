function [Xbin,YMean,YStd] = BinLinear(X,Y,XbinMin,XbinMax,dX )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Xbin=XbinMin:dX:XbinMax;
Nbin=size(Xbin,2);
M=length(Y);
YBinList=cell(1,Nbin);
YMean=zeros(1,Nbin);
YStd=zeros(1,Nbin);
for i=1:Nbin
    YBinList{i}=[];
end

for i=1:M
    K=round((X(i)-XbinMin)/dX+1);
    if K<=Nbin && K>=1
        temp=YBinList{K};
        YBinList{K}=[temp,Y(i)];
    end
end

for i=1:Nbin
    YMean(i)=mean(YBinList{i});
    YStd(i)=std(YBinList{i});
end

end

