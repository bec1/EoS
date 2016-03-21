function ImgOut = SuperSampling( Img,ResizeFactor,SR)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ImgResized=imresize(Img,ResizeFactor,'Box');
ImgOut=ImgResized;
[Yrange,Xrange]=size(ImgResized);
[Xgrid,Ygrid]=meshgrid(1:Xrange,1:Yrange);
%%
% for i=1:Xrange
%     for j=1:Yrange
%         X1=max(1,i-SR);X2=min(Xrange,i+SR);
%         Y1=max(1,j-SR);Y2=min(Yrange,j+SR);
%         Sample=ImgResized(Y1:Y2,X1:X2);
%         ImgOut(j,i)=mean(Sample(:));
%     end
% end

%%Nearest Neighbor Filter
ImgAveraged=ImgResized*0;
for i=-SR:SR;
    for j=-SR:SR
        temp=imtranslate(ImgResized,[i,j]);
        ImgAveraged=ImgAveraged+temp;
    end
end
ImgOut=ImgAveraged/(2*SR+1)^2;
