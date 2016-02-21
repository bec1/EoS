function [ area, data2 ] = get_xsection_area( data, ycuts, pixelonatom )

% fit circles to cross sections
leftedge = ones(size(ycuts));
rightedge = ones(size(ycuts));
for i = 1:size(ycuts,1)
    y = data(ycuts(i),:);
    x = 1:1:size(y,2);
    [leftedge(i),rightedge(i)] = diskfit_topimg(x,y);
end


zout = (1:size(data,1))';

% Fit lines to left and right edges
lfitres = createFitLine(ycuts,leftedge);
rfitres = createFitLine(ycuts,rightedge);

% Get the radius @ z
rads = (rfitres(zout) - lfitres(zout))/2;
area = pi * rads.^2 * pixelonatom^2;

% Make plots
figure;
ax1 = subplot(1,2,1);
imshow(data,[0,1.5]); set(ax1,'YDir','normal'); 
hold on;
for i = 1:size(ycuts,1)
    plot(ax1,leftedge(i),ycuts(i),'rs');
    plot(ax1,rightedge(i),ycuts(i),'rs');
end
plot(ax1,lfitres(zout),zout,'g-');
plot(ax1,rfitres(zout),zout,'g-');
hold off;
title('Fitting circles to slices');

ax2 = subplot(1,2,2);
plot(zout*pixelonatom*10^6,area*10^9,'r.');
xlabel('Z (um)');
ylabel('Area (10^{-9} m^2)');
title('Cross sectional area vs z');

% Flattening
data2 = data;
for i = 1:size(data,1)
    z0 = 0.5*(rfitres(i)+lfitres(i));
    radius = 0.5*(rfitres(i)-lfitres(i));
    for j = 1:size(data,2)
        data2(i,j) = data(i,j) / real(sqrt(radius^2 - (j-z0)^2));
    end
end


end

