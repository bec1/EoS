function [k_t,p_t] = getKP(nofv,edges)

    edges = edges*10;
    nofv(nofv<1e15) = 0;
    
    nofv = smooth(nofv)';
    
    N= length(nofv);
    ns = smooth(nofv)/1.8;
    Vs = smooth(edges);
    warning('off','MATLAB:polyfit:RepeatedPointsOrRescale');
    for i=1:N
        %first do some local smoothing
        %define the start and end point of smoothing
        k1=max(1,i-10);
        k2=min(N,i+10);
        Vf=Vs(k1:k2);nf=ns(k1:k2);
        %Do a 2nd-ord polynomial fitting
        p=polyfit(Vf,nf,2);
        q=polyder(p);
        dndVs(i)=polyval(q,Vs(i));
    end

%     kappa = -(1./(nofv(1:end-1).^2)).*diff(nofv')./diff(edges);

    kappa = -(1./(nofv.^2)).*dndVs;
    
    p = cumsum(nofv,'reverse')*(edges(2)-edges(1));

  
    hbar = 6.63e-34;
    m=9.96323e-27;
    
    n=nofv;
    v=edges;
    
    kf = (abs(6*pi^2*n)).^(1/3);
    ef = hbar^2*kf.^2 / (2*m);
    %plot(v,ef);

    kappa_0 = 1.5./(n.*ef);
    p_0 = 0.4*n.*ef;
    
    k_t = kappa./kappa_0;
    p_t = p./p_0;
    
    plot(p_t,k_t,'.','MarkerSize',20)
    xlim([0 1.2])
%     figure;
%     plot(v,k_t*1e14);
%     hold all
%     plot(v,nofv)
%     ylim([0 max(nofv)])
end