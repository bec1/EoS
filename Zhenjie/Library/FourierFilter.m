function [ Img_Filter] = FourierFilter( Img,CutOffFactor )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[Yrange,Xrange]=size(Img);
[X,Y]=meshgrid(1:Xrange,1:Yrange);

ImgFFT=fft2(Img);
mask1=((X/Xrange).^2+(Y/Yrange).^2)<CutOffFactor^2;
mask2=((X/Xrange).^2+((Y-Yrange+1)/Yrange).^2)<CutOffFactor^2;
mask3=(((X-Xrange+1)/Xrange).^2+(Y/Yrange).^2)<CutOffFactor^2;
mask4=(((X-Xrange+1)/Xrange).^2+((Y-Yrange+1)/Yrange).^2)<CutOffFactor^2;

ImgFFT_Filter=ImgFFT*0;
ImgFFT_Filter(mask1)=ImgFFT(mask1);
ImgFFT_Filter(mask2)=ImgFFT(mask2);
ImgFFT_Filter(mask3)=ImgFFT(mask3);
ImgFFT_Filter(mask4)=ImgFFT(mask4);

Img_Filter=real(ifft2(ImgFFT_Filter));

end

