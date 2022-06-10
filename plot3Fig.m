function plot3Fig(resDataIdx, X)

figure,
scatter3(X(:,1),X(:,2),X(:,3),[],'.r','fill','MarkerEdgeColor','k');
view(-20,5)
% hold on


[N, D] = size(resDataIdx);
% cut: idx = 0
figure
for num = 1:N
    S1 = X(resDataIdx(num,1));
    for dim = 2:D
        idxTemp = resDataIdx(num,dim);
        if idxTemp > 0
          S2 = X(idxTemp);
          plot(S1,S2,'-r');
          hold on
            Sx = [S1(1), S2(1)];                



        end
    end
end
hold off
