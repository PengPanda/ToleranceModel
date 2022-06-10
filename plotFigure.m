function plotFigure(srcimg, locList,x,y,w,h)
%
%
%
%------------------------------------------
n= size(locList,2);
c = [];
figure
imshow(srcimg)
hold on
plot(y, x,'.r');  % y,x
hold on
for i = 1:length(locList(:,1))
    if n == 2
        a = locList(i,1);
        b = locList(i,2);
    elseif n == 3
        c = locList(i,3);
    else
        disp('wrong dimension!')
    end

    if b ~= 0
        xt = [x(a) x(b)];
        yt = [y(a) y(b)];  
        plot(yt, xt,'-r');
%         set(gca,'ydir','reverse')
        hold on
    end
    if ~isempty(c)
        xt = [x(a) x(c)];
        yt = [y(a) y(c)];  
        plot(yt, xt,'-r');
%         set(gca,'ydir','reverse')
        hold on
    end
    
%     pause(0.1)
end

 set(gca,'ydir','reverse')
% axis([0 w 0 h])
% axis off

hold off