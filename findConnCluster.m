% clear
% close all
% clnList=[1,2,3,4,5,2,3,4,5,6,7; 2,3,4,5,6,1,2,3,4,5,8]';

function [cluster_num, cluster_idx_List, ascend_sort_dot_idx_list] = findConnCluster(TRI,clnList, num, x,y,w,h)
% find clusters from 2-reach method result data.

% num = 1;
comp_List = linspace(1,max(TRI(:)),max(TRI(:)));
outliers = setdiff(comp_List,clnList(:));
graph_list = clnList;%(1:len_clnList,:);
% 
% G = sparse([1 1 1 2 2 3 3 4 5 6 7 7 8 9 9  9 9], ...
%            [2 6 8 3 1 4 2 5 4 7 6 4 9 8 10 5 3],true,10,10);
% G = sparse(s,t,true, 10,10);

s = graph_list(:,1)';
t = graph_list(:,2)';
% maxSize = max(max(graph_list(:,1)),max(graph_list(:,2)));
maxSize = max(comp_List);

G = sparse(s,t,true, maxSize,maxSize);
% h = view(biograph(G));
[S,C] = graphconncomp(G ,'Directed',true, 'Weak', true); % find connected components
conn_num = S;
cluster_idx_List = C; % assign clustering labels for every dot that sorted in ascending order.
ascend_sort_dot_idx_list = sort(unique(clnList(:)))';
Asd = ascend_sort_dot_idx_list;
% -----plot clustering graph---------------
Tab = tabulate(cluster_idx_List(:));

clusterIdx = find(Tab(:,2)>num);
outlierIdx = find(Tab(:,2)<=num);

uni_cluster = unique(clusterIdx(:));
cluster_num = numel(uni_cluster);
Colors=hsv(cluster_num);


figure
for k = Asd%Asd    
    
    x_asd = x(k);
%     y_asd = -y(k)+h; % from image
    y_asd = y(k); % load data
    values_list_tem = [];
    for i = uni_cluster'
        cluster_idx = uni_cluster==i;
        if cluster_idx_List(k) == i
            Style = 'x';
            MarkerSize = 8;
            Color = Colors(cluster_idx,:);
            plot(x_asd,y_asd,Style,'MarkerSize',MarkerSize,'Color',Color);

            hold on
%             Legends{cluster_linspace(uni_cluster==i)} = ['Cluster #' num2str(cluster_linspace(uni_cluster==i))];
        elseif ismember(cluster_idx_List(k),outlierIdx)
            Style = 'o';
            Color = [0,0,0];
            MarkerSize = 5;
            plot(x_asd,y_asd,Style,'MarkerSize',MarkerSize,'Color',Color);
%             noise_list = [noise_list; x_asd,y_asd];
            hold on
%             Legends{cluster_linspace(uni_cluster~=i)} = 'Noise';
        else 
            
        end

    end
    
end

% end1=length(Legends)+1;
for out_idx =  outliers;
    x_asd = x(out_idx);
%     y_asd = -y(out_idx)+h;
    y_asd = y(out_idx);% load data
    Style = 'o';
    Color = [0,0,0];
    MarkerSize = 5;
    plot(x_asd,y_asd,Style,'MarkerSize',MarkerSize,'Color',Color);
    hold on
%     disp('?')
end
% Legends{end+1} = 'Noise';
hold off
% legend(Legends);
set(gca,'XLim',[0 w]);
set(gca,'YLim',[0 h]);
axis off
%% flame
% set(gca,'XLim',[0 15]);
% set(gca,'YLim',[14 28]);

title('2-reach method');










