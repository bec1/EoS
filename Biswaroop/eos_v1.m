function [kappa,p,nofv,edges] = eos_v1(profile)

    profile = getDensities(profile);
    
    points = 13/9  * (1:length(profile));
    TFfit = fitTF(profile,points);
    points = points-TFfit.x0;
    
    V = getV(points)*1e34;
    
    figure(2)
    [N,edges,bins] = histcounts(V,70);
   
    
    for i=1:length(edges)
        binlist = [];
        for j=1:length(bins)
            if i==bins(j) % if it belongs to this bin
                binlist = [binlist,profile(j)]; %add to binlist
            end
        end
        nofv(i) = mean(binlist);
        errors(i) = std(binlist);
    
    end
    nofv(isnan(nofv)) =0;
    errorbar(edges,nofv,errors)
% plot(V,profile)

%      figure(3)
%      [kappa,p] = getKP(edges,nofv);
% 
% %     
%     plot(p,kappa);


end

function fitresult = fitTF(profile,points)

    plot(points,profile,'.')
    hold all

    ft = fittype( 'a*max((1-(x-x0)^2 / R^2),0) ^(3/2)', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [160 7e3 172];
    [fitresult, ~] = fit( points', profile, ft, opts );

    plot(fitresult)

end

function n= getDensities(profile,radius)

function V= getV(points)

m=9.96323e-27;
points = points/1e6;
f=24;
omega = 2*pi*f;
V = m*(omega^2) .* (points.^2) / 2;

end

