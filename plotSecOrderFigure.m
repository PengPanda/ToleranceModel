function plotSecOrderFigure(locCell,uniSecLoc,x,y)

cNum = size(locCell,1);
c = [];

for num = 1:cNum
    locList = locCell{num};
    n = size(locList,2);
    figure
    for i = 1:length(locList(:,1))
        if n == 2
            a = locList(i,1);
            b = locList(i,2);
        else
            disp('wrong dimension!')
        end

        if ~isempty(b)
            xt = [x(a) x(b)];
            yt = [y(a) y(b)];  
            plot(yt, xt,'-r');
    %         set(gca,'ydir','reverse')
            hold on
        end

        plot(y, x,'.r');
        
    end
    plot(y(uniSecLoc(num)),x(uniSecLoc(num)),'or')
     hold off
     set(gca,'ydir','reverse')
 
end