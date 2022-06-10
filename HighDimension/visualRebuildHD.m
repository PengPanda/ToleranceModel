function viewImg = visualRebuildHD(srcImg, avgOppChnn,segments,resultList,isolatedList)

reList = unique([resultList;fliplr(resultList)],'rows');
segLabel = unique(segments);

[C ,~, ~] = unique(avgOppChnn,'rows');
% cellTemp = {};
newList = [];
for i = 1:length(C(:,1)) % process the different nodes with the same value.

    segTemp = [];
    for j = 1:length(avgOppChnn(:,1))

        if avgOppChnn(j,1) == C(i,1) && avgOppChnn(j,2) == C(i,2)
            segTemp = [segTemp; segLabel(j)];
            % cellTemp = [cellTemp;  segLabel(j)];   
        end
    end

    if length(segTemp)>1
        nk = nchoosek(segTemp,2);
        newList = [newList; nk];
    end
end

% feaSegMetrix = [avgOppChnn,segments];
reList = unique([reList; double(newList)],'rows'); 

nodeNum = length(reList(:,1))+length(isolatedList(:));

G = digraph(reList(:,1)', reList(:,2)',[], nodeNum);
figure
% [S,C] = graphconncomp( G ); % find connected components
plot(G,'Layout','layered')

bins=conncomp(G);

%% view
viewImg = zeros(size(segments));

for idx= 1:length(segLabel)
    if idx <length(bins)
        viewImg(segments == segLabel(idx)) = bins(idx);
    else
        viewImg(segments == segLabel(idx)) = 0;
    end
end

 
 
 
disp('11')