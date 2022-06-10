% function transform(img)
clear
path = '.\pics\clusterTransform\';
imname = 'extr.bmp';
img = imread([path imname]);


imname(end-4:end) = [];
%*****************
degree = [90, 180];
img_rot45 = imrotate(255-img, 45, 'nearest','loose');
% imshow(img_rot45)


% img_name = [path imname];
imwrite(255-img_rot45,[path imname '_' 'rot45.bmp' ],'bmp');

img_rot90 = imrotate(img, 90, 'nearest');
% imshow(img_rot90)
imwrite(img_rot90,[path imname '_' 'rot90.bmp' ],'bmp');


%*****************
resz = [0.5,2];

img_sz1 = imresize(img,0.5);
imwrite(img_sz1,[path imname '_' 'resz1.bmp' ],'bmp');
% imshow(img_sz1)

img_sz2 = imresize(img,2);
imwrite(img_sz2,[path imname '_' 'resz2.bmp' ],'bmp');
% imshow(img_sz2)

%*****************