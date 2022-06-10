function [x,y,w,h] = loadClusterData(nameData)

% dataDir = '/clusterData/';
dataName = [nameData '.txt'];
Data = load(dataName);
x = Data(:,1);
y = Data(:,2);

figure
plot(x, y, 'k.','MarkerSize',6);
title('Unlabeled Data')

%% bench mark
c = Data(:,3);
len_data = length(x);
len_class = length(unique(c));
% color_idx = ['r', 'g', 'b', 'c', 'm', 'y', 'k', 'w'];

figure
for i = 1:len_class
    idx = find(c == i);
    x_class_i = x(idx);
    y_class_i = y(idx);
    
    plot(x_class_i,y_class_i, 'x')
    hold on
end
hold off
title('Labeled Data')
 h = 1.2*max(x(:)); 
 w = 1.2*max(y(:)); 
