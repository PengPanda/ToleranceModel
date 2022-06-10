% catch data from image
function [corData, w, h] = getData()
src = imread('densityNoise.bmp');
srcImg = im2bw(src); % only the binary image

figure,imshow(srcImg,[]);

[w,h] = size(srcImg);
[l,n] = bwlabel(~srcImg);
cenDotImg = ones(w,h); 

for i = 1:n
    [xi,yi] = find(l == i);   
    x = ceil(mean(xi));
    y = ceil(mean(yi));

    cenDotImg(x,y) = 0;
end

[xd,yd] = find(cenDotImg == 0);
for j = 1:length(xd)
    corData(j,1) = xd(j);%xd
    corData(j,2) = yd(j);%yd
end