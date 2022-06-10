clear 
close all
Data = load('Compound.txt');
x = Data(:,1);
y = Data(:,2);

figure
plot(x, y, '.')
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
    
    plot(x_class_i,y_class_i, '.')
    hold on
end
hold off
title('Labeled Data')
%%
xd = x;
yd = y;

TRI = delaunay(xd,yd);
len = length(TRI);
TRIsp = zeros(size(TRI));
UniTRI =unique(sort(TRI(:)));
new_TRI_Sid = [];
Q = []; % q

for idx2 = 1:length(UniTRI)  % one dimension situation.

    temp_ind = mod(find(TRI == UniTRI(idx2)),len); % find lines begin with the same dot.
    temp_ind(temp_ind == 0) = len;
    temp_col = ceil(find(TRI == UniTRI(idx2))./len);
    temp_TRI = TRI(temp_ind,:); % the row that dot is in.
    temp_TRI_Side = [];
    TRI_Sid = [];
    lenSide = [];

    for idx3 = 1:length(temp_ind);

        xDot1 = xd(temp_TRI(idx3,1));
        xDot2 = xd(temp_TRI(idx3,2));
        xDot3 = xd(temp_TRI(idx3,3));

        yDot1 = yd(temp_TRI(idx3,1));
        yDot2 = yd(temp_TRI(idx3,2));
        yDot3 = yd(temp_TRI(idx3,3));

        a12 = sqrt((xDot2-xDot1)*(xDot2-xDot1)+(yDot2-yDot1)*(yDot2-yDot1));
        b23 = sqrt((xDot2-xDot3)*(xDot2-xDot3)+(yDot2-yDot3)*(yDot2-yDot3));
        c13 = sqrt((xDot3-xDot1)*(xDot3-xDot1)+(yDot3-yDot1)*(yDot3-yDot1));

        if temp_col(idx3) == 1
            lenSide = [lenSide;a12,c13];
            temp_TRI_Side = [temp_TRI_Side; temp_TRI(idx3,2),temp_TRI(idx3,3)];
            elseif temp_col(idx3) == 2
                lenSide = [lenSide;a12,b23];
                temp_TRI_Side = [temp_TRI_Side; temp_TRI(idx3,1),temp_TRI(idx3,3)];
            else 
                lenSide = [lenSide;c13,b23];
                temp_TRI_Side = [temp_TRI_Side; temp_TRI(idx3,1),temp_TRI(idx3,2)];
        end
    end

    Q0 = lenSide./min(lenSide(:));
    Q = [Q;Q0];

end



Q = sort(Q(:));
figure
plot(Q,'LineWidth',2)
title('Q')

T = ppTreshForQ(Q); % threshold for Q; wl = T.
wl = T;

% ---------------------wl = T-------------------
for idx2 = 1:length(UniTRI)  % one dimension situation.

    temp_ind = mod(find(TRI == UniTRI(idx2)),len); % find lines begin with the same dot.
    temp_ind(temp_ind == 0) = len;
    temp_col = ceil(find(TRI == UniTRI(idx2))./len);
    temp_TRI = TRI(temp_ind,:); % the row that dot is in.
    temp_TRI_Side = [];
    TRI_Sid = [];
    lenSide = [];

    for idx3 = 1:length(temp_ind);

        xDot1 = xd(temp_TRI(idx3,1));
        xDot2 = xd(temp_TRI(idx3,2));
        xDot3 = xd(temp_TRI(idx3,3));

        yDot1 = yd(temp_TRI(idx3,1));
        yDot2 = yd(temp_TRI(idx3,2));
        yDot3 = yd(temp_TRI(idx3,3));

        a12 = sqrt((xDot2-xDot1)*(xDot2-xDot1)+(yDot2-yDot1)*(yDot2-yDot1));
        b23 = sqrt((xDot2-xDot3)*(xDot2-xDot3)+(yDot2-yDot3)*(yDot2-yDot3));
        c13 = sqrt((xDot3-xDot1)*(xDot3-xDot1)+(yDot3-yDot1)*(yDot3-yDot1));

        if temp_col(idx3) == 1
            lenSide = [lenSide;a12,c13];
            temp_TRI_Side = [temp_TRI_Side; temp_TRI(idx3,2),temp_TRI(idx3,3)];
            elseif temp_col(idx3) == 2
                lenSide = [lenSide;a12,b23];
                temp_TRI_Side = [temp_TRI_Side; temp_TRI(idx3,1),temp_TRI(idx3,3)];
            else 
                lenSide = [lenSide;c13,b23];
                temp_TRI_Side = [temp_TRI_Side; temp_TRI(idx3,1),temp_TRI(idx3,2)];
        end
    end

    ids = lenSide < wl*min(lenSide(:)); % [1,1;0,1;0...]
    TRI_Sid(:,2:3) = temp_TRI_Side.*ids;
    TRI_Sid(:,1) = UniTRI(idx2);

    new_TRI_Sid = [new_TRI_Sid;TRI_Sid]; %#ok<AGROW>

end
%---------------------------------------------------------------------------------------
w = 35;
h = 35;
figure
% imshow(src)
% hold on;
ppDualplot(new_TRI_Sid,xd,yd) % result
set(get(gca, 'Title'), 'String', 'Result of point set reconstruction.');
hold off

%%
 %----------------------------Area  restriction ---------------------------
figure
% imshow(src)
% hold on;
triplot(TRI,xd,yd)
% set(gca,'ydir','reverse')
% axis off
hold on;
plot(xd,yd,'.r');
hold off

