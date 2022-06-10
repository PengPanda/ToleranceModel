% find discrete dots location
% input: sImg ------ images
function [xd,yd] = findLocation(sImg)

src = sImg;
if size(src,3)>1
    srcImg = im2bw(rgb2gray(src),0.1); % only the binary image
else
    srcImg = im2bw(src,0.1);
end
se = strel('disk',2);
srcImg = imopen(srcImg,se);

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

figure,imshow(cenDotImg,[]);
[xd,yd] = find(cenDotImg == 0);