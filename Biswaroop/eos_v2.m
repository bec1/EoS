function [kappa,p,nofv,edges] = eos_v2(n)
  
%% Get n as a function of V
    points = 13/9  * (1:length(n));
    TFfit = fitTF(n,points);
    points = points-TFfit.x0;
    V = getV(points);
    [nofv,nofv_errors,edges] = getnofv(n,V);
    
    figure(2)
    %errorbar(edges,nofv,nofv_errors)
    plot(V,n);

    figure(3)
    [kappa,p] = getKP(nofv,edges);
% 
% %     
   % plot(V(1:end-1),p);


end

function   [nofv,nofv_errors,edges] = getnofv(n,V)
%% Get n as a function of v by binning
    [~,edges,bins] = histcounts(V*1e34,110);
    edges = edges*1e-34;
    for i=1:length(edges)
        binlist = [];
        for j=1:length(bins)
            if i==bins(j) % if it belongs to this bin
                binlist = [binlist,n(j)]; %add to binlist
            end
        end
        nofv(i) = mean(binlist);
        nofv_errors(i) = std(binlist);

    end
    nofv(isnan(nofv)) =0;
    
end

function fitresult = fitTF(profile,points)
%% fit the TF profile to find the center
    plot(points,profile,'.')
    hold all
    [xData, yData] = prepareCurveData( points', profile/1e16 );
    ft = fittype( 'a*max((1-(x-x0)^2 / R^2),0) ^(3/2)', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [160 7 172];
    [fitresult, ~] = fit(xData,yData, ft, opts );

    plot(points,fitresult(points)*1e16)

end



function V= getV(points)
%% Calculate V in Joules
m=9.96323e-27;
points = points/1e6;
f=24;
omega = 2*pi*f;
V = m*(omega^2) .* (points.^2) / 2;

end

