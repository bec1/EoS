function [rads,xfits] = getradii(raw)

s= size(raw);


for i=1:s(1)
    data = raw(i,:);
    [rads(i),xfits(i).fit] = fitrad(data);
end

end
    
function [rad,xfitresult] = fitrad(data)

M=13/9; %Magnification
points=M *(1:length(data))'; %x pixel positions in microns

    
ft = fittype( 'a*sqrt(max(r^2 - (x-x0)^2,0))+c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.574856778470422 0.913207413757913 50 80];

% Fit model to data.
xfitresult = fit(points, data', ft, opts );
rad = xfitresult.r;
end


