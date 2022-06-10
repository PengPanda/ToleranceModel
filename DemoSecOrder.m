
% main function
clear
close all

addpath('.\testData\')
addpath('.\clusterData\')
addpath(genpath('.\Evaluation\'));
%% -----------parameter setting----------
wn1 = 1; %clustering : 100
wn2 = 1;

%% ui input image
[pname,adrname]=uigetfile('.\Evaluation\pics\clusterTransform\icon.bmp','Select Your Images'); %'*.jpg','*.bmp', '*bmp'

        if exist(strcat(adrname,pname), 'file')

            src = imread(strcat(adrname,pname));
            figure
            
            imshow(src);
            [h,w,~] = size(src);
%             srcData = getSpecShape(shape); 
            [xd,yd] = findLocation(src);
        else 
            warndlg('No image input','warning !');
            return;
        end
 filename = pname;
filename(end-3:end)=[];
savePath = '.\Evaluation\pics\clusteringdata\TwoReach\';
%% input image
% src = imread('sqr.bmp');
% srcImg = im2bw(src); % only the binary image
% [xd,yd] = findLocation(src);
% [h,w,~] = size(src);

%% input real-word image
% ImgName = '132.jpg';
% Img = imread(ImgName);
% [avgOppChnn,segments]= calFeature(ImgName);
% h = ceil(2*max(abs(avgOppChnn(:,1))))+10;
% w = ceil(2*max(abs(avgOppChnn(:,2))))+10;
% 
% xd = avgOppChnn(:,1);
% yd =avgOppChnn(:,2);
% 
% src = ones(h,w);
%% load clustering data
% nameData = 'Flame';
% [yd,xd,h,w] =loadClusterData(nameData);
% src = [];

%% 
tic
TRI = delaunay(xd,yd);
[adjList, adjSecList, uniSecLoc] = findAdjMatrix(TRI);
plotFigure(src,adjList,xd,yd,w,h) % adjList: 1st order

Task = 1; % task == 1: 1st order; task ==2: 1st and 2nd order.
[dataList, ratioList] = calLengthRatioList(unique([adjList;fliplr(adjList)],'rows'),Task, xd, yd);
% Task = 2;
% [dataSecList, ratioSecList] = calLengthRatioList(adjSecList,Task, xd, yd);

[Q, oList]= sort(ratioList(:));
ymax = max(Q);
figure
plot(Q,'LineWidth',2)
title('Q')
ylim([0,ymax])
grid on

order = 1;

th=0.12*wn1;
orderLabel = 1;
T = findTreshold(Q,th,orderLabel); % threshold for Q; wl = T.
wl = T;
disp('first order')

%%----------------------------------------------------
sortedDataList = [];
for iData = oList'
    sortedDataList = [sortedDataList; dataList(iData,:)];
end

resDataList = sortedDataList(Q <= wl,: );
plotFigure(src, resDataList,xd,yd,w,h)

%----------------------------fill triangles----------------------------
one_reachList = FindTriangle(resDataList);   
    %% trifill

    figure
    imshow(src)
    hold on
    ppDualplot(one_reachList,yd,xd,w,h) % result
    % set(get(gca, 'Title'), 'String', 'Result of point set topological reconstruction.');
    hold on
    triFill(one_reachList,yd,xd);
    hold off
title('Result of 1-reach method')


%%-------------------------------------------------------
% outlier removel

[secDataList, secRatioList] = calSecRatio(resDataList,xd,yd); %
% 1order-->2order
% [secDataList, secRatioList] = calSecRatio(ratioSecList,xd,yd);


[Q, oList]= sort(secRatioList(:));
ymax = max(Q);
figure
plot(Q,'LineWidth',2)
title('Q')
ylim([0,ymax])
grid on

order = 2;

scaleInd = 1;
th = 0.035*wn2;
orderLabel = 2;
T = findTreshold(Q,th,orderLabel); % threshold for Q; wl = T.

sortedDataList = [];
for iData = oList'
    sortedDataList = [sortedDataList; secDataList(iData,:)];
end
resList = sortedDataList(Q < T,: ); % <= 2019.11.2

if ~isempty(resList)  % 0?

    clnList = cleanResList(resList);
    % save([savePath   filename '_2' '.mat'], 'clnList'); % save resultDataR

    plotFigure(src,clnList,xd,yd,w,h)

    %% ---------find clusters and outliers------------------

    outlier_neib = 2;
    [S,C,sort_List] = findConnCluster(TRI,clnList,outlier_neib,yd,xd,w,h);
    TriList = FindTriangle(clnList);   
    
    %% save clustering method
%     save([savePath filename '.mat'],'C')
    %% trifill

    figure
    imshow(src)
    hold on
    ppDualplot(TriList,yd,xd,w,h) % result
    % set(get(gca, 'Title'), 'String', 'Result of point set topological reconstruction.');
    hold on
    triFill(TriList,yd,xd);
    hold off
else
    figure
    imshow(src)

end
toc



