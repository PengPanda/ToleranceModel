% evaluation
% input: S, result {(x1,y1);(x2,y2);(..)}
%        GT, human depicted result(ground thruth) : {(pair),(),()}
% out put
function [P,R,F] =  PRevaluation(S,GT)

len_s = numel(S)/2;
S0 = S;
S0(:,[1 2]) = S0(:,[2 1]);
Sr=S;
% St = [S0;S];
idx=0;
sigS=[];
for i = 1:len_s
%     [c,ia,ib] = intersect(S0(i),S,'rows');
    c = ismember(S0(i,:),Sr,'rows');
    if c == 1        
        Sr(i-idx,:) = [];
        idx = idx+1;
    elseif c==0
        sigS = [sigS; S0(i,:)];
    end
end
%% ------------------------
len_g = numel(GT)/2;
GT0 = GT;
GTr=GT;
GT0(:,[1 2]) = GT0(:,[2 1]);
idx=0;
% St = [S0;S];
sigGT=[];

for j = 1:len_g
%     [c,ia,ib] = intersect(S0(i),S,'rows');
    c = ismember(GT0(j,:),GTr,'rows');
    if c == 1
        GTr(j-idx,:) = [];
        idx = idx+1;
    elseif c==0
        sigGT = [sigGT; GT0(j,:)];
    end
end
%%
H0 = [Sr;sigS];
G0 = [GTr;sigGT];

H1 = H0;
G1 = G0;

H1(:,[1 2]) = H1(:,[2 1]);
G1(:,[1 2]) = G1(:,[2 1]);

H = [H0; H1];
G = [G0; G1];
%% ----------------------
intNum = intersect(H,G,'rows');
TP = numel(intNum)/4;
FP = numel(H0)/4 - TP;
FN = numel(G0)/4 - TP;

P = TP/(TP+FP);
R = TP/(TP+FN);

F=2*P*R/(P+R);


