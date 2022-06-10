function wNum = wightNum(Num,order)
% 
% close all
% order=2;
% Num = 1000;
% Num =-20000:1:20000;
if order == 1
    a = 0.0005;
elseif order == 2
    a = 0.00005;
else
    print('wrong order')
end
c = 0;

y = 2./(1 + exp(-a.*(Num-c)))-1;

wNum = 1-y;
% 
% figure
% plot(Num,y,'-')
% axis on