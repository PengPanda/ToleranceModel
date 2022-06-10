%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML110
% Project Title: Implementation of DBSCAN Clustering in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

clc;
clear;
close all;

%% Load Data

X = load('Spiral.txt');
w=1.2*max(X(:,2));
h=1.2*max(X(:,1));

%%
% [X,w,h]= getData();
% X=data.X;


%% Run DBSCAN Clustering Algorithm
tic
epsilon=2;
MinPts=3;
% Y = [X(:,2),h-X(:,1)]; % our data
Y = [X(:,1),X(:,2)];
IDX=DBSCAN(Y,epsilon,MinPts);


%% Plot Results

PlotClusterinResult(Y, IDX,w,h);
toc
% title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);