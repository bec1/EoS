function f = efrad(rad)
% calculate the fermi energy given a thomas-fermi radius (output in Hz)
xi = 0.376;
omega = 2*pi*24;
m = 9.96e-27;
h = 6.63e-34;

ef = m*omega^2 *(rad.^2)/(2*xi);
f = ef/h;

end
