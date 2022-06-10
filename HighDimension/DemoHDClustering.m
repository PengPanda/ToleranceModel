% high dimension demo
%--------------------------

% input maxLength: maxR
% dimension amount : Dim
% --------------------------------------
clear
close all
addpath('..\testData\');
%% load Dm dimension data
% srcData = load('data');
% sz = size(srcData);


%% load image features
srcimage = imread('275.jpg');
figure
imshow(srcimage)
tic
[feaList, feaLoc, segments] = calFeatureHD(srcimage);
% srcData = [feaList feaLoc];
srcData = [feaList];

    figure
    scatter3(srcData(:,1),srcData(:,2),srcData(:,3));
%% pamameters structure
param.maxR = 10;

% param = struct(maxR,Dim);

%% ------------------------------------

TRI = delaunayn(srcData,{''});  % T: num X (Dm+1)
param.Dm = size(TRI,2);

%% triplot
% if param.Dm == 2
%     figure
%     triplot(TRI,srcData(:,1),srcData(:,2));
% elseif param.Dm == 3
%     figure
%     scatter(TRI,srcData);
% else
%     fprint('warning, cannot plot high demension data!');
% end

%% (n-1)*n/2
adjList = findAdjMetrixHD(TRI, param);
%%
task = 1; % 1 for 1st order, 2 for 2nd 
[dataList, ratioList] = calLengthRatioListHD(adjList, task, srcData);

%%
[Q, oList]= sort(ratioList(:));
ymax = max(Q);
figure
plot(Q,'LineWidth',2)
title('Q')
ylim([0,ymax])
grid on

orderLabel = 1;
NumQ1 = length(Q);
weightNum = wightNum(length(Q),orderLabel);
th = 0.12*weightNum; % 0.12

T = findTreshold(Q,th,orderLabel); % threshold for Q; wl = T.
wl = T;
disp('aa')
%%----------------------------------------------------

sortedDataList = [];
for iData = oList'
    sortedDataList = [sortedDataList; dataList(iData,:)];
end

resDataList = sortedDataList(Q <= T,: ); % result of fisrt order
% plotFigure(srcimage, resDataList,xd,yd,w,h)

%% -------------------------------------------------------

 
% outlier removel

[secDataList, secRatioList] = calSecRatioHD(resDataList,feaList); %
% 1order-->2order
% [secDataList, secRatioList] = calSecRatio(ratioSecList,xd,yd);


[Q2, oList]= sort(secRatioList(:));
ymax = max(Q2);
figure
plot(Q2,'LineWidth',2)
title('Q2')
ylim([0,ymax])
grid on

orderLabel = 2;
wn = 1;
NumQ2 = length(Q2);
% Ratio_Q2_Q1 =wn*NumQ2/NumQ1
weightNum = wightNum(length(Q2),orderLabel);
th = 0.035*weightNum*wn;
% th = 0.035*weightNum*Ratio_Q2_Q1;
% th = 0.12*weightNum/Ratio_Q2_Q1; % 0.035

T = findTreshold(Q2,th,orderLabel); % threshold for Q; wl = T.

sortedDataList = [];
for iData = oList'
    sortedDataList = [sortedDataList; secDataList(iData,:)];
end
resList = sortedDataList(Q2 <= T,: );
% plotFigure(src,resList,xd,yd,w,h)

%% visual rebuild---------------------------------------------------------
% viewImg = visualRebuildHD(srcimage, srcData, segments, resDataList); % one step

isolatedList = setdiff(unique(segments(:)),unique(resList(:))); % isolated nodes or outliers

viewImg = visualRebuildHD(srcimage, srcData, segments, resList, isolatedList); % two step

%% -------edge map----
BW = edge(viewImg,'Canny',0.001);
se = strel('disk',2);
I2 = imdilate(BW,se);
figure
imshow(I2,[])

resizeImg = imresize(srcimage,size(I2));

view_Res_Img = resizeImg;
view_Res_Img(:,:,1) = resizeImg(:,:,1) + uint8(I2*255);
view_Res_Img(:,:,2) = resizeImg(:,:,2) + uint8(I2*255);
view_Res_Img(:,:,3) = resizeImg(:,:,3) + uint8(I2*255);

figure
imshow(view_Res_Img,[])
imwrite(view_Res_Img,'view_Res_Img.png','png');
%% -----------------
% FlattenedData = viewImg(:)'; % 
% MappedFlattened = mapminmax(FlattenedData, 0, 1); % 
% MappedData = reshape(MappedFlattened, size(viewImg)); % 
% resmap = im2uint8(MappedData);
% imwrite(resmap,'resmap.png','png');


toc