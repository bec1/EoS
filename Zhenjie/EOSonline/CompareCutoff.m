%%
filename='/Users/Zhenjie/Data/2016-02-23/02-23-2016_22_30_24_top.fits';
[Pt1,Kt1,nsort,Vsort1,Zsort,Ptsel,Ktsel,EF,P]=EOS_Online( filename ,'ROI1',[215,25,312,402],...
    'ROI2',[209,187,335,243],'ShowOutline',1,'TailRange',[85,325],'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,...
    'CutOff',inf,'kmax',1.1,'kmin',0.15,'BGSubtraction',BGimg,'ShowTailor',1);


%%
[Pt2,Kt2,nsort,Vsort2,Zsort,Ptsel,Ktsel,EF,P]=EOS_Online( filename ,'ROI1',[215,25,312,402],...
    'ROI2',[209,187,335,243],'ShowOutline',1,'TailRange',[85,350],'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,...
    'CutOff',inf,'kmax',1.1,'kmin',0.15,'BGSubtraction',BGimg,'ShowTailor',1);

%%
[Pt3,Kt3,nsort,Vsort3,Zsort,Ptsel,Ktsel,EF,P]=EOS_Online( filename ,'ROI1',[215,25,312,402],...
    'ROI2',[209,187,335,243],'ShowOutline',1,'TailRange',[65,370],'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',0,...
    'CutOff',inf,'kmax',1.1,'kmin',0.15,'BGSubtraction',BGimg,'ShowTailor',1);
%%
h=figure
plot(Vsort1/hh,Pt1,'r.','DisplayName','[85,325]');
hold on
plot(Vsort2/hh,Pt2,'b.','DisplayName','[85,350]');
plot(Vsort3/hh,Pt3,'g.','DisplayName','[65,370]');
ylim([0,4]);xlim([0,6000])
xlabel('V(Hz)');ylabel('P/P_0');
yyaxis right
plot(Vsort1/hh,nsort,'k*','DisplayName','n(V)');
ylabel('n');
legend('show');
hold off
%%
plot(Vsort1/hh,Kt1,'r.','DisplayName','[85,325]');
hold on
plot(Vsort2/hh,Kt2,'b.','DisplayName','[85,350]');
plot(Vsort3/hh,Kt3,'g','DisplayName','[65,370]');
ylim([0,4]);xlim([0,6000])
xlabel('V (Hz)');ylabel('\kappa/\kappa_0');
legend('show')
hold off