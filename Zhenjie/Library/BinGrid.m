function [ XMean,YMean,XStdM,YStdM,XStd,YStd ] = BinGrid( Xdata,Ydata,Xgrid,thres )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Xgrid=sort(Xgrid);
M=length(Xgrid);
index=1:M;

Xcell=cell(M-1,1);
Ycell=cell(M-1,1);

for i=1:M-1
    Xcell{i}=[];
    Ycell{i}=[];
end

N=length(Xdata);

for i=1:N
    mark=Xgrid<Xdata(i);
    K=max(index(mark));
    if (length(K)>0) && (K<M)
        Xcell{K}=[Xcell{K},Xdata(i)];
        Ycell{K}=[Ycell{K},Ydata(i)];
    end
end

XMean=Xgrid(1:end-1)*0;
XStdM=XMean;
YMean=XMean;
YStdM=XMean;
XStd=XMean;
YStd=XMean;

for i=1:M-1
    if length(Xcell{i})>=thres
        XMean(i)=mean(Xcell{i});
        YMean(i)=mean(Ycell{i});
        XStdM(i)=std(Xcell{i})/sqrt(length(Xcell{i}));
        YStdM(i)=std(Ycell{i})/sqrt(length(Ycell{i}));
        XStd(i)=std(Xcell{i});
        YStd(i)=std(Ycell{i});
    else
        XMean(i)=NaN;XStdM(i)=NaN;XStd(i)=NaN;
        YMean(i)=NaN;YStdM(i)=NaN;YStd(i)=NaN;
    end
end



end

