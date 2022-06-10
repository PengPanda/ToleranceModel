function srcData = getSpecShape(shape)
% get lacation from input image 
% shape: input shape images, black background, white targets, size: 700x700 pixels.
% ----------------------------------------
% srcData = zeros(dataSize);
if size(shape,3)>1
    srcImg = im2bw(rgb2gray(shape),0.1); % only the binary image
else
    srcImg = im2bw(shape,0.1);
end
% figure,imshow(srcImg,[]);
se = strel('disk',2);
srcImg = imopen(srcImg,se);
[w,h] = size(srcImg);
[l,n] = bwlabel(~srcImg);
cenDotImg = zeros(w,h); 

for i = 1:n
    [xi,yi] = find(l == i);   
    x = ceil(mean(xi));
    y = ceil(mean(yi));

    cenDotImg(x,y) = 1;
end
% figure,imshow(cenDotImg,[]);
srcData = cenDotImg;