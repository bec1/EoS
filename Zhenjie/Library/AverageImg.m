function AveragedImg = AverageImg( Imglist )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

N=length(Imglist);
NSum=0;
for i=1:N
    Nsum=NSum+Imglist{i};
end
AveragedImg=Nsum/N;

end

