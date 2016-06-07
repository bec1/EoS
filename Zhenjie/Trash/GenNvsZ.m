function [n,z] = GenNvsZ( Img,ROI1,ROI2,pixelsize,z0,ellipticity )
%GENNVSZ Summary of this function goes here
%This function returns a normalized density n as a function of z, z=0 is
%the center of the axial trapping potential, which should be provided by
%z0.
%Img is the image to be processed, should already be converted to a number
%map
%ROI1 is the region which we use to get the density 
%ROI2 is the region which we use to get the outline of the trap
%pixelisze is the length of one pixel on the atom
%z0 is the center of the cloud.

[x1,x2,~,~,Yt,p1,p2 ]=CylinderOutline( Img,ROI2 );
x1=round(x1);x2=round(x2);
h=figure
imagesc(Img);
%check if the outline is good
hold on
plot(x1,Yt,'r.','MarkerSize',5);
plot(x2,Yt,'r.','MarkerSize',5);
caxis([0,45]);
pause()
close(h)
%check end
Y=ROI1(2):ROI1(4)
[n,Z] = GetnvsZ( Img,x1,x2,Y,pixelsize,ellipticity);
n=n';
z=Z'-z0;
end

