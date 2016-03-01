filename='\\Elder-pc\j\Elder Backup Raw Images\2016\2016-02\2016-02-23\02-23-2016_22_37_04_top.fits';
[Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel]=EOS_Online( filename );

scatter(Pt,Kt);
hold on
xlim([0,6])
[ KappaTilde, PTilde, ~, ~ ] = VirialUnitarity(  2, 7,200 , 3 );
ylim([0,4])
plot(PTilde,KappaTilde);
hold off

Kappa=GetKappavsV(nsort,Vsort);

