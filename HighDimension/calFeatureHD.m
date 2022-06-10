function [feaList,feaLoc, segments] = calFeatureHD(src)
%--------------------------------------------------------
%
%
%---------------------------------------------------------
% first to get VLFeat 0.9.17 ready.
% run('D:\program\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup')
% close all
% clear
[w,h,~] = size(src); 

if w>=h
    W = 500;
    H = 500*h/w;
else
    H = 500;
    W = w/h*500;
end

srcImg = imresize(src,[W,H],'bilinear');

regionSize = 50 ; % size of supuer pixel 40 . 10
regularizer = 1500;% recom: 500



% [ww,hh,dd] = size(im);
useLab = 1;
if useLab

    im = rgb2lab(srcImg);
    
    r_im = im(:,:,1); % L
    g_im = im(:,:,2); % a
    b_im = im(:,:,3); % b
else 
    im = double(srcImg);
    r_im = im(:,:,1);
    g_im = im(:,:,2);
    b_im = im(:,:,3);
end

des_im = double(zeros(size(im)));
r_des_im = des_im(:,:,1);
g_des_im = des_im(:,:,2);
b_des_im = des_im(:,:,3);

segments = vl_slic(single(im), regionSize, regularizer)+1;

% figure
% imshow(imlab)
% title('imlab')
spLabel = unique(segments);
% max_seg = max(segments(:));
rgbChnn = [];

for item = spLabel'
    idx = find(segments == item); 
    r_des_im(idx) = mean(r_im(idx(:)));
    g_des_im(idx) = mean(g_im(idx(:)));
    b_des_im(idx) = mean(b_im(idx(:)));
end



des_im = cat(3,r_des_im,g_des_im,b_des_im);


%--------Create adjacent map, in lab spcace-------------- 
mean_node = [];
avgOppChnn = [];

zero_seg = im2bw(zeros(size(segments)));
% aux_seg = zero_seg;
% adj_matrix = {};    % define adjacent matrix
% se = strel('square',3);
feaLoc = [];
Loc = [];

% % other cues
% [ESmap,Edge]= EdgeSaliency(double(srcImg));
% 
%     extracting local cues, e.g. color,luminance,texture etc.
% sigma = 0.1; 
% cues = getLocalcues(srcImg,sigma,Edge);
% mean_cues = [];
% %


for i = spLabel'
    aux_seg = zero_seg;
    idx = find(segments == i);

    [xx,yy] = ind2sub(size(segments),idx);
    Xc = mean2(xx);
    Yc = mean2(yy);

    Loc = [Loc; Xc, Yc];
    
    mean_node_r = mean(mean(r_des_im(idx)));  
    mean_node_g = mean(mean(g_des_im(idx)));
    mean_node_b = mean(mean(b_des_im(idx)));
%     flum = (mean_node_r + mean_node_g + mean_node_b)/3;
    
    mean_node = [mean_node; mean_node_r, mean_node_g, mean_node_b];  % mean of superpixel
    
%     mean_cues_1 = mean(mean(cues(idx,1)));  
%     mean_cues_2 = mean(mean(cues(idx,2)));  
%     mean_cues_3 = mean(mean(cues(idx,3)));  
%     mean_cues_4 = mean(mean(cues(idx,4)));  % texture
%     mean_cues = [mean_cues; mean_cues_1, mean_cues_2, mean_cues_3];

    
end

% des_im = cat(3,l_des_im,a_des_im,bb_des_im);
% des_im = reshape(des_im,size(im));
% figure
% imshow(des_im)
% title('lab space')

rgbChnn = mean_node; % rgb or lab
% fea_cues = mean_cues;
% rgbChnn = avgOppChnn;


feaLoc = 100*(Loc-min(Loc(:)))./(max(Loc(:))-min(Loc(:))+eps);
% feaList = avgOppChnn;
feaList = 100*(rgbChnn-min(rgbChnn(:)))./(max(rgbChnn(:))-min(rgbChnn(:))+eps);


% feaList = [rgbChnn, avgOppChnn];
disp('features done!')



