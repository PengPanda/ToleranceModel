% k-means
close all
clear

%%---
X = load('Spiral.txt');
w=1.2*max(X(:,2));
h=1.2*max(X(:,1));


%%
% [X,w,h]= getData();
%%
k=2;
IDX = kmeans(X,k);

Y = [X(:,2),h-X(:,1)];
%% Plot Results
% Y1(:,2) = X(:,2); %max(max(Y(:,2)))-Y(:,2)+120;
% Y1(:,1) = X(:,1);
PlotClusterinResult(Y, IDX,w,h);