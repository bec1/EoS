function n = TFfun( P,z )
%P(1):mu
%P(2):Z0
%P(3): Rtf
n=real( P(1)^(3/2)* (1-(z-P(2)).^2/(P(3)).^2).^(3/2));
end

