function [adjIdx, adjDis] = geneConnectiveGraph(srcDataList, params)
% input : high-Dimension data, (D-dimension)
% output: Length Ratio List 
% 
% other notes: n links per dot.
% use k-nn
%-----------------------------------------------------
% [N, D] = size(srcDataList); % N X D


X = srcDataList;
Y = srcDataList;
k = params.k;
p = params.p;


[mIdx,mD] = knnsearch(X,Y,'K',k,'Distance','minkowski','P',p);

adjIdx = mIdx;
adjDis = mD;