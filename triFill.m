function triFill(TRI,x,y)

% fill the area of triangle
% 2018.8.15 by peng peng
%

for i = 1:length(TRI(:,1))
    a = TRI(i,1); % current start piont.
    b = TRI(i,2);
    c = TRI(i,3);  
    if (b ~= 0) && (c ~= 0)
            idxb = find(TRI(:,1) == b);     
            if max(TRI(idxb,2) == c) || max(TRI(idxb,3) == c)
                xt = [x(a) x(b) x(c)];
                yt = [y(a) y(b) y(c)];  
                fill(xt, yt,'r');
                hold on
            end      
    end

end
