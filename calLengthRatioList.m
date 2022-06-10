function [dataList, lineRatio] = calLengthRatioList(adjList, Task, x, y)

% task == 1: 1st order; task ==2: 1st and 2nd order.

if Task == 1

    uniNum = unique(adjList(:,1));
    lenLine = [];
    lineRatio = [];
    dataList = [];
    for item = uniNum'
        locTemp = adjList(:,1) == item;
        a = adjList(locTemp,1);
        b = adjList(locTemp,2);
        lenItemLine = [];
        
        for i = 1:length(a)
            lenItemLineTemp = sqrt((x(a(i))-x(b(i)))^2 + (y(a(i))-y(b(i)))^2);
            lenItemLine = [lenItemLine, lenItemLineTemp];
        end
        dataList = [dataList; adjList(locTemp,:)];
        lenLine = [lenLine, lenItemLine];
        lineRatio = [lineRatio, lenItemLine./min(lenItemLine)];
    end

elseif Task == 2
    
    len = length(adjList);
    lenLine = {};
    lineRatio = {};

    for cNum = 1:len
        cList = adjList{cNum};
        uniNum = unique(cList);
        cellLenLine = [];
        cellLineRatio = [];

        for item = uniNum'
            locTemp = cList(:,1) == item;
            a = cList(locTemp,1);
            b = cList(locTemp,2);
            lenItemLine = [];
            
            for i = 1:length(a)
                lenItemLineTemp = sqrt((x(a(i))-x(b(i)))^2 + (y(a(i))-y(b(i)))^2);
                lenItemLine = [lenItemLine, lenItemLineTemp];
            end
            cellLenLine = [cellLenLine, lenItemLine];
            cellLineRatio = [cellLineRatio, lenItemLine./min(lenItemLine)];
        end
        lenLine = [lenLine, cellLenLine];
        lineRatio = [lineRatio, cellLineRatio];
    end
    dataList = [];

else
    disp('wrong task label')
end