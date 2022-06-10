function reData = drawDots(srcData,r, imLines)
%%=================================================
% function: draw dots for function DiscreteDataGene;
% srcData: inpute location
% [x,y]: coordinate of dot;
% r : radius of dots;
% Coded by Peng Peng
%%==============================================

% r = 10;
% srcData = load('srcData.mat');
% srcData = srcData.srcData;

[w,h] = size(srcData);

idx = find(srcData');
[x, y] = meshgrid(1:w, 1:h);

for point = 1:length(idx)
% disp(point)
    [x0, y0] = ind2sub(size(srcData), idx(point));

    srcData(((x-x0).*(x-x0) + (y-y0).*(y-y0))<=r*r) = 1;

end
reData = srcData;

% if exist('imLines','var')  % haven't complete here
%     imLines(reData) = 1;
%     reData = imLines;
% end