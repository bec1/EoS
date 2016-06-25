PList=[];
TTildeList=[];
kappaTildeList=[];
%% 20160609A
load('Data/2016-06-09A-Processed.mat');
subplot(2,1,1);
scatter(Ppick,kappa2Tpick);
hold on
line([0,0.3],[1.1,1.1],'linewidth',3)
hold off
xlabel('Impurity Concentration');
subplot(2,1,2);
scatter(TTilde2pick,kappa2Tpick);
hold on
line([0.1,0.5],[1.1,1.1],'linewidth',3)
hold off
xlabel('T/T_F');
%%
PList=[PList,Ppick];
TTildeList=[TTildeList,TTilde2pick];
kappaTildeList=[kappaTildeList,kappa2Tpick];

%% 20160609B
load('Data/2016-06-09B-Processed.mat');
subplot(2,1,1);
scatter(Ppick,kappa2Tpick);
hold on
line([0,0.3],[1.1,1.1],'linewidth',3)
hold off
xlabel('Impurity Concentration');

subplot(2,1,2);
scatter(TTilde2pick,kappa2Tpick);
hold on
line([0.15,0.5],[1.1,1.1],'linewidth',3)
hold off
xlabel('T/T_F');

%%
PList=[PList,Ppick];
TTildeList=[TTildeList,TTilde2pick];
kappaTildeList=[kappaTildeList,kappa2Tpick];

%% 20160516
load('Data/2016-05-16-Processed.mat');
subplot(2,1,1);
scatter(Ppick,kappa2Tpick);
hold on
line([0.08,0.2],[1.1,1.1],'linewidth',3)
hold off
xlabel('Impurity Concentration');
subplot(2,1,2);
scatter(TTilde2pick,kappa2Tpick);
hold on
line([0.25,0.5],[1.1,1.1],'linewidth',3)
hold off
xlabel('T/T_F');
%%
PList=[PList,Ppick];
TTildeList=[TTildeList,TTilde2pick];
kappaTildeList=[kappaTildeList,kappa2Tpick];

%%
scatter3(PList,TTildeList,kappaTildeList)
xlabel('Impurity Concentration');ylabel('T/T_F');zlabel('KappaTilde');
zlim([1,1.2])
hold on
for i=1:length(PList)
    line([PList(i),PList(i)],[TTildeList(i),TTildeList(i)],[0,kappaTildeList(i)],'linewidth',2)
end
hold off