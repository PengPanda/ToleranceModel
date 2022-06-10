function adjList = findAdjMetrixHD(TriList, param) 
% (n-1)*n/2
% if(nargin<4 ), a; end

twoColumList = [];
% R = param.maxR;
dim = param.Dm;
%%
for i = 1:dim-1
    for j = i+1:dim
        twoColumList = [twoColumList; TriList(:,i), TriList(:,j)];
    end   
end

%% 
uniList = unique(twoColumList,'rows');
len = length(uniList(:,1));

for i = 1:len
    listValue = uniList(i,:);
    if listValue(1,1) ~= 0
        [~,~,iList] = intersect(fliplr(listValue), uniList, 'rows');
        if ~isempty(iList)
            uniList(iList,:) = [0,0];
        end
    end
end
adjListTemp = uniList;
adjListTemp(uniList == 0) = [];
adjList = [adjListTemp(1: length(adjListTemp(:))/2); adjListTemp(length(adjListTemp(:))/2+1:end)]'; % first order
disp('hh')
%%
