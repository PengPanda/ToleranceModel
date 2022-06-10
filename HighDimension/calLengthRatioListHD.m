function [dataList, lineRatio] = calLengthRatioListHD(adjList, Task, feaList,wf)
wf=0.2;
% task == 1: 1st order; task ==2: 1st and 2nd order.
% feaList: feature list, feaList = {x1,x2,x3,...,xn}, include N value x, and each-
% dimenision is Dim;

% for 2 dimension: feaList = [xList, yList]';


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

%             lenItemLineTemp = sqrt(sum((feaList(a(i),:) - feaList(b(i),:)).^2));
%             lenItemLine = [lenItemLine, lenItemLineTemp];
            
           lenItemLineTemp_color = sum((feaList(a(i),1:3) - feaList(b(i),1:3)).^2);
%            lenItemLineTemp_cues = sum((feaList(a(i),4:7) - feaList(b(i),4:7)).^2);
           lenItemLineTemp_position = sum((feaList(a(i),4:end) - feaList(b(i),4:end)).^2);
                
           lenItemLineTemp = sqrt(wf*wf*lenItemLineTemp_position + lenItemLineTemp_color);
           lenItemLine = [lenItemLine, lenItemLineTemp];
        end
        dataList = [dataList; adjList(locTemp,:)];
        lenLine = [lenLine, lenItemLine];
        lineRatio = [lineRatio, lenItemLine./(min(lenItemLine)+eps)];
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
                lenItemLineTemp = sqrt((feaList(a(i),:) - feaList(b(i),:)).^2);
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