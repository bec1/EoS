function n=getDensities(profile,rads)
areas = pi*(rads*1e-6).^2;
profile_c = profile./areas;
n = profile_c./(13e-6 /9);
end