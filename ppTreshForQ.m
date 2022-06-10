function T = ppTreshForQ(Q)
%------------------------------------------------------------
% Evaluate the threshhold for Q 
% Input: Q
% Output: T = threshhold;
% Coded by Peng Peng. Contact me at peng_panda@163.com.
% Date: 2018.3.21
%------------------------------------------------------------
Q = sort(Q);
N = length(Q);
t_exp = 0.12; % experical
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
        % temp_D2_Q = Q(i+1) + Q(i-1) -2*Q(i);
    end
    
    D1_Q = [D1_Q, temp_D1_Q];
    % D2_Q = [D2_Q, temp_D2_Q];
    

%-----------------------------------------------------  
end
%  t = Q(G == min(G));
%  t = t(1);

% % T = t - 1/(1+exp(t-2)) + 0.5;
%  w = 0;
%  T = t - w*(t - 2.2)^3;

%  D = D1_Q.*D2_Q;
% D = Q'.*Q'.*D1_Q;
D = Q'.*D1_Q;
 
%  figure
%  plot(D1_Q,'r')
% hold on

% % plot(D2_Q,'k')
% % hold on

% plot(D,'G')
% hold on

% plot(Q)
% grid on
% hold off

Qm = [];
for i = 1:N
    m = mean(Q(1:i));
    Qm = [Qm,D(i)./m];
end



 figure
 plot(Q,'LineWidth',1)
 hold on
 plot(Qm,'-r','LineWidth',1)
 set(get(gca, 'Title'), 'String', 'Q & Qm');
 hold on
 legend('Q','Q_{ID1}');

grid on

%-----------------find T------------------
indx = find(Qm >= t_exp,1,'first');
if indx <= N
    T = Q(indx);
else
%     T = 0.5*(Q(indx)+Q(indx+1)); %(indx+1)
    T = Q(indx); %(indx+1)
end

if ~isempty(T)
    T = T(1);
    else
    T = Q(end); % if T dosen't exsit, T = max(Q).
end
%--------------------plot T in Q graph-------
xt = [find(Q >= T, 1 )+1 find(Q >= T, 1 )+1]; % actually, no need to +1;
yt = [0 T];
plot(xt,yt,'--m','LineWidth',2)
plot(xt,yt,'.k','MarkerSize',20)
hold on

xt = [1 min(find(Q >= T))+1]; % no need to +1
yt = [T T];
plot(xt,yt,'--m','LineWidth',1.5)
plot(xt,yt,'.k','MarkerSize',20)

xt = [1 min(find(Q >= T))+1]; % no need to +1; th = 0.12
yt = [t_exp t_exp];
plot(xt,yt,'--g','LineWidth',1.5)
plot(xt,yt,'.k','MarkerSize',20)


hold off