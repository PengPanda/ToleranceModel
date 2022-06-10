function [avgOppChnn,segments] = calFeature(ImgName)
%--------------------------------------------------------
%
%
%---------------------------------------------------------
% first to get VLFeat 0.9.17 ready.
% run('D:\program\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup')
% close all
% clear
regionSize = 40 ; % size of supuer pixel
regularizer = 10 ;

im = double(imread(ImgName));
% [ww,hh,dd] = size(im);
r_im = im(:,:,1);
g_im = im(:,:,2);
b_im = im(:,:,3);

des_im = double(zeros(size(im)));
r_des_im = des_im(:,:,1);
g_des_im = des_im(:,:,2);
b_des_im = des_im(:,:,3);

segments = vl_slic(single(im), regionSize, regularizer)+1 ;
% figure
% imshow(imlab)
% title('imlab')
spLabel = unique(segments);
max_seg = max(segments(:));
for item = spLabel'
    idx = find(segments == item); 
    r_des_im(idx) = mean(r_im(idx(:)));
    g_des_im(idx) = mean(g_im(idx(:)));
    b_des_im(idx) = mean(b_im(idx(:)));
end

des_im = cat(3,r_des_im,g_des_im,b_des_im);
figure
imshow(des_im,[])

%--------Create adjacent map, in lab spcace-------------- 
mean_node = [];
avgOppChnn = [];

zero_seg = im2bw(zeros(size(segments)));
aux_seg = zero_seg;
adj_matrix = {};    % define adjacent matrix
se = strel('square',3);

for i = spLabel'
    aux_seg = zero_seg;
    idx = find(segments == i);
%     aux_seg(idx) = 1;
%     
%     aux_seg = imdilate(aux_seg,se);
%     aux_seg = aux_seg.*double(segments);
%     adj_n = unique(aux_seg(aux_seg > 0));
%     adj_node = [i, adj_n'];
%     
%     if (adj_node == i)  % just one pixel
%         adj_matrix{i+1} = adj_matrix{i};
%     else
%         adj_matrix{i+1} = adj_node;  % adjacent matrix
%     end
    
    
    mean_node_r = mean(mean(r_des_im(idx)));  
    mean_node_g = mean(mean(g_des_im(idx)));
    mean_node_b = mean(mean(b_des_im(idx)));
    mean_node = [mean_node; mean_node_r, mean_node_g, mean_node_b];  % mean of superpixel
    frg = mean_node_r - mean_node_g;
    fby = mean_node_b - (mean_node_r + mean_node_g)/2;
    avgOppChnn = [avgOppChnn; frg, fby];

    % std_node_l = std2(l_imlab(idx));
    % std_node_a = std2(a_imlab(idx));
    % std_node_b = std2(b_imlab(idx));
    % std_node = [std_node; std_node_l, std_node_a, std_node_b];  % std of superpixel
    
    % l_des_im(idx) = mean_node_l;
    % a_des_im(idx) = mean_node_a;
    % bb_des_im(idx) = mean_node_b;
    
end

% des_im = cat(3,l_des_im,a_des_im,bb_des_im);
% des_im = reshape(des_im,size(im));
% figure
% imshow(des_im)
% title('lab space')



