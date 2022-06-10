function [ secDataList, secRatioList] = calSecRatio(resDataList, x, y)
%

adjList = [resDataList; fliplr(resDataList)];

uniList = unique(adjList(:,1));
secList = {};
for uItem = uniList'
    tempList = adjList(:,1);
    uRows = find(tempList == uItem);
    secListTempLocation = [];
    secListTemp =[];
        for un = uRows'
            secListTempLocation = tempList == adjList(un,2);
            secListTemp = [secListTemp; adjList(secListTempLocation,:)];
            % secListTemp = adjList(uRows,2);          
        end
        secList = [secList; unique(secListTemp,'rows')];
end
% adjSecList = unique(secList,'rows'); % second order
adjSecList =secList;
uniSecLoc = uniList; % location

%%------------------------------------------------------------------------------
%%--------------------------------------------------------------------------------
% adjList = [resDataList; fliplr(resDataList)];

len = length(adjSecList);
lenLine = {};
lineRatio = {};
dataListTemp = {};

% list
dataList = [];% same as dataListTemp, but is formated as list;
ratioList = [];

for cNum = 1:len
    cList = adjSecList{cNum};
    uniNum = unique(cList(:,1));
    cellLenLine = [];
    cellLineRatio = [];
    cellDataList = [];

    for item = uniNum'
        locTemp = cList(:,1) == item;
%         if sum(locTemp(:)) ~= 0
            a = cList(locTemp,1);
            b = cList(locTemp,2);
            lenItemLine = [];

            for i = 1:length(a)
                lenItemLineTemp = sqrt((x(a(i))-x(b(i)))^2 + (y(a(i))-y(b(i)))^2);
                lenItemLine = [lenItemLine, lenItemLineTemp];
            end
            cellDataList = [cellDataList; cList(locTemp,:)];
            cellLenLine = [cellLenLine, lenItemLine];
        % cellLineRatio = [cellLineRatio, lenItemLine./min(lenItemLine)];
%          end
    end

    % cell data
    dataListTemp = [dataListTemp; cellDataList];
    lenLine = [lenLine; cellLenLine];
    lineRatio = [lineRatio; cellLenLine./min(cellLenLine(:))];

    % list data
    dataList = [dataList; cellDataList];
    ratioList = [ratioList, cellLenLine./min(cellLenLine(:))];
end

secRatioList = ratioList;
secDataList = dataList;

%%--------plot figure-----------

% plotSecOrderFigure(dataListTemp,uniSecLoc,x,y)
% disp('oo')