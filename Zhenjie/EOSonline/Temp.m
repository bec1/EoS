%%
load('85325');
Pt1=Ptbin;
Kt1=KtMean;
KtStd1=KtStd;

%%
load('85350');
Pt2=Ptbin;
Kt2=KtMean;
KtStd2=KtStd;

%%
load('65370');
Pt3=Ptbin;
Kt3=KtMean;
KtStd3=KtStd;

%%
plot(Pt1,Kt1,Pt2,Kt2,Pt3,Kt3)

%%
errorbar(Pt1,Kt1,KtStd1,'MarkerFaceColor','r','Marker','diamond',...
    'LineStyle','none',...
    'Color','r','DisplayName','[85,325]');
hold on
errorbar(Pt2,Kt2,KtStd2,'MarkerFaceColor','g','Marker','diamond',...
    'LineStyle','none',...
    'Color','g','DisplayName','[85,350]');
errorbar(Pt3,Kt3,KtStd3,'MarkerFaceColor','b','Marker','diamond',...
    'LineStyle','none',...
    'Color','b','DisplayName','[65,370]');
hold off
legend('show');xlim([0,4]);
xlabel('P/P_0');ylabel('\kappa/\kappa_0');