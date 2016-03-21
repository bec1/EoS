function [Xfilted,Yfilted] = ClusterFilter(Xdata,Ydata,dx,dy,Nmin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N=length(Xdata);
Xfilted=Xdata;
Yfilted=Ydata;
for i=1:N
%     if i==843
%         disp(' ');
%     end
    x0=Xdata(i);
    y0=Ydata(i);
    mark1=abs(Xdata-x0)<dx;
    mark2=abs(Ydata-y0)<dy;
    if sum(mark1.*mark2)<Nmin;
        Xfilted(i)=NaN;
        Yfilted(i)=NaN;
    end
end
Xfilted(isnan(Xfilted))=[];
Yfilted(isnan(Yfilted))=[];
end

