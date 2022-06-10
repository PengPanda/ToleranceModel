function clnData = cleanResList(resList)

% eliminate the replicate values 
%
rlist = unique(resList,'rows');
len_s = size(rlist,1);


rlist0 = rlist;
rlist_r = rlist;

rlist0(:,[1 2]) = rlist0(:,[2 1]);
idx = 0;
sigList = [];
for i = 1:len_s
%     [c,ia,ib] = intersect(S0(i),S,'rows');
    c = ismember(rlist0(i,:),rlist_r,'rows');
    if c == 1        
        rlist_r(i-idx,:) = [];
        idx = idx+1;
    elseif c==0
        sigList = [sigList; rlist0(i,:)];
    end
end

clnData =[rlist_r; sigList] ;