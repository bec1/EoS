function num = AtomNumber( img,pixelsize,sigma, Nsat,thres )
%img: the imgage
%pixelsize, the actual pixel size of the image (on the atoms), the unit
%should be kept same as cross section
%sigma: absorption cross section of the atom
%Nsat: saturation count.
%thres: ignore the pixels that have a photon counts lower than thres
OD=real(-log((img(:,:,1)-img(:,:,3))./(img(:,:,2)-img(:,:,3))));
IC=(img(:,:,2)-img(:,:,1))/Nsat;
if ~exist('thres','var')
    % third parameter does not exist, so default it to something
    thres = 0;
end
num=(OD+IC)*pixelsize/sigma;
woa=img(:,:,2)-img(:,:,3);
num(woa<thres)=0;
% num(num>50)=0;
end

