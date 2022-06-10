function T = findTreshold(sortedList,th, orderLabel)

Q = sort(sortedList);
N = length(Q);
t_exp = th; % experical
G = [];
temp_D2_Q = 0;
temp_D1_Q = 0;
D1_Q = [];
D2_Q = [];
D = [];

for i = 1:N

%-----------the 1st and 2nd order derivative.------------------
    if i>1 && i < N 
        temp_D1_Q = (Q(i+1) - Q(i-1))/2;
    end    
    D1_Q = [D1_Q, temp_D1_Q];
    
    
    if i>2 && i < N-1 % the second order
        temp_D2_Q = abs((Q(i+1)+Q(i-2) - Q(i-1) - Q(i)))/4;
    end    
    D2_Q = [D2_Q, temp_D2_Q];
    

%-----------------------------------------------------  
end
if orderLabel == 1
    D = Q'.*D1_Q;

elseif orderLabel == 2
    D = Q'.*Q'.* D2_Q;

end

Qm = [];
for i = 1:N
    m = mean(Q(1:i));
    Qm = [Qm,D(i)./m];
end
meanQm = mean(Qm(:))


 figure
 plot(Q,'LineWidth',1)
 hold on
 plot(Qm,'-r','LineWidth',1)
 set(get(gca, 'Title'), 'String', 'Q & Qm');
 hold on
 legend('Q','Qm');

grid on

%-----------------find T------------------
indx = find(Qm >= t_exp,1,'first');
if indx == N
    T = Q(indx);
else
    T = 0.5*(Q(indx)+Q(indx+1)); %(indx+1)
end

if ~isempty(T)
    T = T(1);
    else
    T = Q(end); % if T dosen't exsit, T = max(Q).
end
%--------------------plot T in Q graph-------
xt = [find(Q >= T, 1 ) find(Q >= T, 1 )]; % actually, no need to +1;
yt = [0 T];
plot(xt,yt,'--m','LineWidth',2)
plot(xt,yt,'.k','MarkerSize',20)
hold on

xt = [0 find(Q >= T, 1 )]; % no need to +1
yt = [T T];
plot(xt,yt,'--m','LineWidth',1.5)
plot(xt,yt,'.k','MarkerSize',20)

xt = [0 find(Q >= T, 1 )]; % no need to +1; th = 0.12
yt = [t_exp t_exp];
plot(xt,yt,'--g','LineWidth',1.5)
plot(xt,yt,'.k','MarkerSize',20)


hold off