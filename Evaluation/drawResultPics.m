function drawResultPics(srcData, line_TRI, r, lineWidth, name)
%===============================================
% draw result images from line_TRI generated from geneResultData.
% line_TRI: line_TRI from geneResultData
% r: radio of dots.
% lineWidth: line width.
%===============================================
% clear 
% close all
% 
% [pname,adrname]=uigetfile('*.jpg','*.bmp', '*bmp');
%         if exist(strcat(adrname,pname), 'file')
% 
%             shape = imread(strcat(adrname,pname));
%             if ismember(size(shape), [700,700])
%                 srcData = getSpecShape(shape);       
%             else
%                 warndlg('Wrong Size','warning !');
%                 return;
%             end
% 
%         else 
%             warndlg('No image input','warning !');
%             return;
%         end



savePath = 'E:\tolerance space\ExpForTh\ExPics\drawReImg\';

w = 700;
h = 700;
% r = 4;
er = lineWidth;
img = zeros(w,h);
[x,y] = meshgrid(1:w, 1:h);

matData = line_TRI;
Dots = find(srcData);

lines = Dots(matData);


for i = 1: length(lines(:,1))
    [x1, y1] = ind2sub([w,h], lines(i, 1)); 
    [x2, y2] = ind2sub([w,h], lines(i, 2));
 
    D = round(sqrt((x2 - x1)^2 + (y2 - y1)^2));
    
    x_round = linspace(x1,x2,D);
    y_round = linspace(y1,y2,D);
    
   for j = 1:length(x_round)
        x_in = x(((x-x_round(j)).^2 + (y-y_round(j)).^2) <= er*er);
        y_in = y(((x-x_round(j)).^2 + (y-y_round(j)).^2) <= er*er);

        img(x_in, y_in) = 1;
   end
end

% imLines = imrotate(img, -90);
imLines = img;

reData =drawDots(srcData,r);
reData(find(imLines)) = 1;

imwrite(reData,[savePath '\' name '.bmp']); 