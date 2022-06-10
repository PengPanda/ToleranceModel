% high dimension demo
%--------------------------

% input maxLength: maxR
% dimension amount : Dim
% --------------------------------------
clear
close all
addpath('..\testData\');
addpath('.\CGVSsalient\');
addpath('E:\PandaSpaceSyn\WorkingSpace\Tolerance\ToleranceModel\Evaluation\BSDSdata\BSR_bsds500\BSDS500\data\images\train\');
%% load Dm dimension data
% srcData = load('data');
% sz = size(srcData);

wn1 = 1; %10
wn = 1;
wf = 0.1;
%-------------------
Img_name_string = '35058.jpg';
res_name = Img_name_string;
res_name(end-3:end) = [];
res_wn_string = ['.\hardresults\' res_name '_' num2str(wf)];
%% load image features
srcimage = imread(Img_name_string);
[w,h,d]=size(srcimage);

if d < 3
    srcimage = cat(3,srcimage,srcimage,srcimage);
end



figure
imshow(srcimage)
tic
% [colorList, feaLoc, feaCues,segments] = calFeatureHD(srcimage);
% srcData = [colorList feaCues feaLoc];
[colorList, feaLoc,segments] = calFeatureHD(srcimage);
srcData = [colorList feaLoc];
% srcData = [colorList];

%     figure
%     scatter3(srcData(:,1),srcData(:,2),srcData(:,3));

%% ------------------------------------
% USEtrigngulation

% TRI = delaunayn(srcData,{''});  % T: num X (Dm+1)
% param.Dm = size(TRI,2);
% 
% adjList = findAdjMetrixHD(TRI, param);



%% use KNN
k= 4;
D = squareform(pdist(srcData,'euclidean')); %data: row,sample; column: feature
[sortval,sortpos] = sort(D,2,'ascend');
neighborIds= sortpos(:,2:k+1);

adjList = [];
for i = 1:length(srcData(:,1))
    for j = 1:k
        adjList = [adjList; i,neighborIds(i,j)];
    end
    
end


%%
task = 1; % 1 for 1st order, 2 for 2nd 
[dataList, ratioList] = calLengthRatioListHD(adjList, task, srcData,wf);

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
th1 = 0.12*wn1; %weightNum; % 0.12

T = findTreshold(Q,th1,orderLabel); % threshold for Q; 
wl = T;
% wl = max(Q(:));
disp('aa')
%%----------------------------------------------------

sortedDataList = [];
for iData = oList'
    sortedDataList = [sortedDataList; dataList(iData,:)];
end

resDataList = sortedDataList(Q <= wl,: ); % result of fisrt order
% plotFigure(srcimage, resDataList,xd,yd,w,h)

%% -------------------------------------------------------

 
% outlier removel

[secDataList, secRatioList] = calSecRatioHD(resDataList,srcData,wf); %
% 1order-->2order
% [secDataList, secRatioList] = calSecRatio(ratioSecList,xd,yd);
% wn = 0.5

[Q2, oList]= sort(secRatioList(:));
ymax = max(Q2);
figure
plot(Q2,'LineWidth',2)
title('Q2')
ylim([0,ymax])
grid on

orderLabel = 2;
% wn = 50;
% NumQ2 = length(Q2);
% meanQ2 = mean(Q2(:))
% weightNum = wightNum(length(Q2),orderLabel);
% th = 0.035*weightNum*wn;
th = 0.035*wn;
% th = 0.12*weightNum/Ratio_Q2_Q1; % 0.035

T2 = findTreshold(Q2,th,orderLabel); % threshold for Q; wl = T.
maxnum = max(secDataList(:));
sortedDataList = [];
for iData = oList'
    sortedDataList = [sortedDataList; secDataList(iData,:)];
end
resList = sortedDataList(Q2 <= T2,: );
% plotFigure(src,resList,xd,yd,w,h)

%% visual rebuild---------------------------------------------------------

isolatedList1 = setdiff(unique(segments(:)),unique(resDataList(:))); % isolated nodes or outliers
isolatedList = setdiff(unique(segments(:)),unique(resList(:))); % isolated nodes or outliers

%%
viewImg = findConnClusterHD(srcData, segments, resList, isolatedList,maxnum);
toc
figure
imagesc(viewImg)
colorbar
axis off
%%


% viewImg = visualRebuildHD(srcimage, srcData, segments, resList, isolatedList); % two step

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
resized_mask = imresize(I2,[w,h]);
imwrite(resized_mask,[res_wn_string '_mask' '.png'],'png');
resized_view_Res_Img = imresize(view_Res_Img, [w,h]);
imwrite(resized_view_Res_Img,[res_wn_string '.png'],'png');

%% -----------------
% FlattenedData = viewImg(:)'; % 
% MappedFlattened = mapminmax(FlattenedData, 0, 1); % 
% MappedData = reshape(MappedFlattened, size(viewImg)); % 
% resmap = im2uint8(MappedData);
% imwrite(resmap,'resmap.png','png');


