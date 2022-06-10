% clear
% close all
% clnList=[1,2,3,4,5,2,3,4,5,6,7; 2,3,4,5,6,1,2,3,4,5,8]';

% function [cluster_num, cluster_idx_List, ascend_sort_dot_idx_list] = findConnClusterHD(TRI,clnList, num, x,y,w,h)
% find clusters from 2-reach method result data.
function viewImg = findConnClusterHD(avgOppChnn,segments,resultList,isolatedList, maxnum)

% num = 1;
reList = unique([resultList;fliplr(resultList)],'rows');
segLabel = unique(segments);

comp_List = linspace(1,max(reList(:)),max(reList(:)));
outliers = isolatedList;
graph_list = reList;%(1:len_clnList,:);
% 
% G = sparse([1 1 1 2 2 3 3 4 5 6 7 7 8 9 9  9 9], ...
%            [2 6 8 3 1 4 2 5 4 7 6 4 9 8 10 5 3],true,10,10);
% G = sparse(s,t,true, 10,10);

s = graph_list(:,1)';
t = graph_list(:,2)';
maxSize = maxnum;

G = sparse(s,t,true, maxSize,maxSize);
% h = view(biograph(G));
[S,C] = graphconncomp(G ,'Directed',true, 'Weak', true); % find connected components
conn_num = S;
cluster_idx_List = C; % assign clustering labels for every dot that sorted in ascending order.
ascend_sort_dot_idx_list = sort(unique(resultList(:)))';
Asd = ascend_sort_dot_idx_list;

%%
viewImg = 0-ones(size(segments));
% figure
for k = Asd%Asd    
   viewImg(segments==segLabel(k)) = cluster_idx_List(k);
end

% for out_idx =  outliers';
%     viewImg(segments == out_idx) = max(viewImg(:))+1;
% end











