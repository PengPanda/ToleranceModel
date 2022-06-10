%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML110
% Project Title: Implementation of DBSCAN Clustering in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function PlotClusterinResult(X, IDX,w,h)
    figure,
    k=max(IDX);

    Colors=hsv(k);

    Legends = {};
    for i=0:k
        Xi=X(IDX==i,:);
        if i~=0
            Style = 'x';
            MarkerSize = 8;
            Color = Colors(i,:);
            Legends{end+1} = ['Cluster #' num2str(i)];
        else
            Style = 'o';
            MarkerSize = 6;
            Color = [0 0 0];
            if ~isempty(Xi)
                Legends{end+1} = 'Noise';
            end
        end
        if ~isempty(Xi)
            plot(Xi(:,1),Xi(:,2),Style,'MarkerSize',MarkerSize,'Color',Color);
        end
        hold on;
    end
    hold off;
%     axis equal;
    axis on;
    set(gca,'xlim',[0,h])%将x轴上的取值范围设置为[x1,x2]
    set(gca,'ylim',[0,w])%将x轴上的取值范围设置为[x1,x2]
    
%     set(gca,'XTick',[0,h])%将x轴上的取值范围设置为[x1,x2]
%     set(gca,'YTick',[0,w])%将x轴上的取值范围设置为[x1,x2]
%     grid on;
    legend(Legends);
%     legend('Location', 'NorthEastOutside');

end