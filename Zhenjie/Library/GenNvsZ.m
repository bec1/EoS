function [n,z] = GenNvsZ( Img,ROI1,ROI2,pixelsize,z0,ellipticity,varargin)
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

ShowOutline=false;
Nmethod=0;

for i =1:length(varargin)
    if ischar(varargin{i})
    switch varargin{i}
        case 'ShowOutline'
            ShowOutline=varargin{i+1};    
        case 'Nmethod'
            Nmethod=varargin{i+1};
    end
    end
end


[x1,x2,~,~,Yt,p1,p2 ]=CylinderOutline( Img,ROI2 );
%x1=round(x1);x2=round(x2);

% check if ShowOutline is asked
if ShowOutline
    h=figure;
    imagesc(Img);
    %check if the outline is good
    hold on
    plot(x1,Yt,'r.','MarkerSize',5);
    plot(x2,Yt,'r.','MarkerSize',5);
    vector1=x1(end)-x1(1)+(Yt(end)-Yt(1))*1i;
    vector2=(x2(end)-x2(1))+(Yt(end)-Yt(1))*1i;
    theta=abs(angle(vector1/vector2))/pi*180;
    caxis([-10,45]);
    questdlg(['I am just giving you some time to check the out line, press any key to continue, the cone angle is',num2str(theta)]);
    pause();
    close(h)
end

%check end
Y=ROI1(2):ROI1(4);
[n,Z] = GetnvsZ( Img,x1,x2,Y,pixelsize,ellipticity,'Nmethod',Nmethod);
n=n';
z=Z'-z0;
end

