function [adjList, adjSecList,uniSecLoc] = findAdjMatrix(TRIList)
% find 1 or 2 order adjacent matrix
% input: TRI list
% outpot: 1 for 1st order, 2 for 2nd
% order.
%-------------------------------------------------------------------------

adjListTemp1 = [TRIList(:,1), TRIList(:,2)];
adjListTemp2 = [TRIList(:,1), TRIList(:,3)];
adjListTemp3 = [TRIList(:,2), TRIList(:,3)];
adjListWithRedundancy = [adjListTemp1; adjListTemp2; adjListTemp3];

% clear adjListTemp1 adjListTemp2 adjListTemp3

uniList = unique(adjListWithRedundancy,'rows');
len = length(uniList(:,1));

for i = 1:len
    listValue = uniList(i,:);
    if listValue(1,1) ~= 0
        [~,~,iList] = intersect(fliplr(listValue), uniList, 'rows');
        if ~isempty(iList)
            uniList(iList,:) = [0,0];
        end
    end
end
adjListTemp = uniList;
adjListTemp(uniList == 0) = [];
adjList = [adjListTemp(1: length(adjListTemp(:))/2); adjListTemp(length(adjListTemp(:))/2+1:end)]'; % first order



allAdjList = [adjListTemp1; adjListTemp2; adjListTemp3; fliplr(adjListTemp1); fliplr(adjListTemp2); fliplr(adjListTemp3)];
uniList = unique(allAdjList(:,1));
secList = {};
for item = uniList'
    tempList = allAdjList(:,1);
    uRows = find(tempList == item);
    secListTempLocation = [];
    secListTemp =[];

        for un = uRows'
            secListTempLocation = tempList == allAdjList(un,2);
            secListTemp = [secListTemp; allAdjList(secListTempLocation,:)];
            % secListTemp = allAdjList(uRows,2);
            
        end

        secList = [secList; unique(secListTemp,'rows')];
end
% adjSecList = unique(secList,'rows'); % second order
adjSecList =secList;
uniSecLoc = uniList;

disp('pp')
