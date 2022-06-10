function [thresh_value,IDX]= ppClusterForTh(value_list,idx_list, cluster_num, Q2)
% this function is uesd for 
%

addpath('.\toolbox\DBSCAN\')
%% ------test---------

%  data = load('idx_list.mat');
% idx_list =  idx_list;
% value_list = ones(size(idx_list));


%%
use_dbscan = 1;
if ~use_dbscan
    k=cluster_num;
    IDX =kmeans(idx_list',k);
    thresh_value = [];
    for i = unique(IDX)'
       thresh_value_temp = value_list(find(IDX == i,1,'first'));
       thresh_value = [thresh_value,thresh_value_temp];
    end
elseif use_dbscan    
    epsilon = 45;
    minpts = 15;
    IDX = DBSCAN(idx_list',epsilon,minpts);
    thresh_value = [];
    flag = [];
    for i = unique(IDX)'
        if i>0  % 0 is noise
            thresh_value_temp = value_list(find(IDX == i,1,'first'));
            flag = [flag, idx_list(find(IDX == i,1,'last'))];
            thresh_value = [thresh_value,thresh_value_temp];
        end
    end
    
end

maxQ2 = max(Q2(:));
if isempty(thresh_value) || (i<2 && (length(idx_list) - max(flag))/length(idx_list) < 0.1)
    if length(unique(IDX) == 1) ==1
        thresh_value = .5*min(Q2);
        IDX = 1;
    else
        thresh_value = max(Q2);
        IDX = length(Q2);
    end
end

% figure
% plot(IDX,'^')
% % axis = 1:max(idx_list);
% disp('sss')
