function [ secDataList, secRatioList] = calSecRatioHD(resDataList, feaList, wf)
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


            for i = 1:length(a) % lab 3 channels
                lenItemLineTemp_color = sum((feaList(a(i),1:3) - feaList(b(i),1:3)).^2);
                lenItemLineTemp_position = sum((feaList(a(i),4:end) - feaList(b(i),4:end)).^2);
                
                lenItemLineTemp = sqrt(wf*wf*lenItemLineTemp_position + lenItemLineTemp_color);
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
    lineRatio = [lineRatio; cellLenLine./(min(cellLenLine(:))+eps)];

    % list data
    dataList = [dataList; cellDataList];
    ratioList = [ratioList, cellLenLine./(min(cellLenLine(:))+eps)];
end

secRatioList = ratioList;
secDataList = dataList;

%%--------plot figure-----------

% plotSecOrderFigure(dataListTemp,uniSecLoc,x,y)
disp('oo')