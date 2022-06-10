% clear
% A = [1,2,3,4,1,2,1; 2,3,4,5,3,4,5];
% DoubList = A';


function TriList = FindTriangle(DoubList)
%------------------------------------------------------------
% find triangles from double list and then implement to function triFill()
%
% input: double value list
%----------------------------------------------------------
S = DoubList;

Sn = S;
% [sort_S,Idx]= sort(Sn,2,'ascend');

UniA = unique(S(:,1));
TriList=[];
for elmt = UniA'
    idx_list = find(Sn(:,1) == elmt);
    
    A_list = Sn(idx_list',:);
    
    if numel(A_list(:,2)) > 1
        Res_List = nchoosek(A_list(:,2),2); % permutation and combination
        for posib_com = Res_List'

            temp_com = [posib_com(1),posib_com(2)];
            [LIA,LOCB] = ismember(temp_com,Sn,'rows','legacy');
            TriList_tem=[];

            if LIA        
                TriList_tem(1,1) = elmt;
                TriList_tem(:,2:3) = temp_com;
                TriList=[TriList; TriList_tem];
            else
                TriList_tem(1,1) = elmt;
                TriList_tem(1,2) = posib_com(1);
                TriList_tem(1,3) = 0;

                TriList_tem(2,1) = elmt;
                TriList_tem(2,2) = posib_com(2);
                TriList_tem(2,3) = 0;

                TriList=[TriList; TriList_tem];
            end
        end
    else
        TriList_tem(1,1) = elmt;
        TriList_tem(1,2) = A_list(1);
        TriList_tem(1,3) = 0;

        TriList_tem(2,1) = elmt;
        TriList_tem(2,2) = A_list(2);
        TriList_tem(2,3) = 0;

        TriList=[TriList; TriList_tem];
    end


end





















