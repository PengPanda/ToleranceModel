
%====================================================
close all
clc
clear all
addpath('./pics/')

%% -------enter your name------------
disp('Please enter your name first!')
numberStr = 'wj';

%% ---------------------------------------

button = 1;
savePath = 'E:\PandaSpaceSyn\WorkingSpace\Tolerance\ToleranceModel\Evaluation\pics\clusteringdata\GT\'; % save path

Screen_charactors= get(0);
Screen_Size = Screen_charactors.ScreenSize;
centerX = Screen_Size(1);
centerY = Screen_Size(2);
width = Screen_Size(3);
height = Screen_Size(4);

%%------get test image--------------
[pname,adrname]=uigetfile('E:\PandaSpaceSyn\WorkingSpace\Tolerance\ToleranceModel\Evaluation\pics\clusterTransform\icon.bmp','Select Your Images'); %'*.jpg','*.bmp', '*bmp'
if exist(strcat(adrname,pname), 'file')

    shape = imread(strcat(adrname,pname));
    f = figure;
    imshow(shape);
    [w,h,~] = size(shape);
    set(gcf,'position',[(width-3*w)/2,(height-h)/2,w,h])
    movegui(f,[width+200,height/4]);


    srcData = getSpecShape(shape); 
%             if ismember(size(shape), [700,700]) % if w and h changed, remember changed here
%                 srcData = getSpecShape(~shape);      
%             else
%                 warndlg('Wrong Size','warning !');
%                 return;
%             end

else 
    warndlg('No image input','warning !');
    return;
end

% %% -------------message box------------
% prompt = {'Pls input the Name of this result image:'};
% dlg_title = 'Input Name';
% num_lines = 1;
% def = {''};
% answer = inputdlg(prompt,dlg_title,num_lines,def);
% numberStr = answer{1};
% %%---------------------------------------

% src = ~srcData;
% 
% srcImg = im2bw(src); % only the binary image
% figure,imshow(srcImg,[]);

%%----------------------------------
% srcData = load ('srcData.mat');
% srcData = srcData.srcData;
dataSize = size(srcData);

[x, y] = find(srcData == 1); % 0 or 1
len = length(find(srcData == 1));
id_list = 1:len; 

 


% Screen_charactors_1= get(1);
% Screen_Size_1 = Screen_charactors_1.ScreenSize;

% movegui(f,[width+300,height/4]);


flag = 0;
button =1;
colorlist = {'ro','bo','go','yo','ko','r^','b^','g^','y^','k^'};
num = 2;
cluster_list=ones(1,len);



while 1  % while click mid key, mouse respond stops
    
    if flag==0  % initial figure 
        x_col1 =h-x(id_list(:))+1;
        y_col1 = y(id_list(:));
        figure
        set(gcf,'position',[(width-w)/2,(height-h)/2,w,h])
        plot( y_col1, x_col1,'ro', 'Linewidth', 2); %plot
    end 
    axis([0 w 0 h]);   
    

    if button == 2 % click mid mouse key to complete mission (left:1,mid:2,right:3)
        hold off
        close 
        disp('~~~~~Exist~~~')
        break;       
    else
        if flag>0
            close
            figure
            set(gcf,'position',[(width-w)/2,(height-h)/2,w,h])
            for j = 1:num
                yj = y(cluster_list==j);
                xj = h-x(cluster_list==j)+1;
                clr = colorlist{j};
                plot(yj, xj, clr, 'Linewidth', 2); %plot
                hold on    
            end
            axis([0 w 0 h]);   
        end
%         hold off
        
        
        [x_ms(1), y_ms(1), button] = ginput(1);
        if button == 3  % if the right key is clicked, cluster +1
            num = num+1;
            [x_ms(1), y_ms(1), button] = ginput(1);
            if button == 2 % click mid mouse key to complete mission (left:1,mid:2,right:3)
                hold off
                close 
                disp('~~~~~Exist~~~')
                break;   
            end   
        end
        
        [x_ms(2), y_ms(2)] = ginput(1);
        % plot(x_ms, y_ms, 'r-', 'Linewidth', 2);
        
        x_ms = round(x_ms);
        y_ms = h-round(y_ms)+1;
        
        x_msMax = max(x_ms(1), x_ms(2));
        x_msMin = min(x_ms(1), x_ms(2));
        
        y_msMax = max(y_ms(1), y_ms(2));
        y_msMin = min(y_ms(1), y_ms(2));
        
%         plot(x_ms, y_ms, 'r-', 'Linewidth', 2);
        
        for i=1:len
           if x(i)> y_msMin && x(i)< y_msMax && y(i)> x_msMin && y(i)< x_msMax 
               cluster_list(i)=num;
           end
        end
        
    end
    flag = flag+1;
end

uni = unique(cluster_list);
for i = 1:length(uni)
    resultData(cluster_list==uni(i))=i;
end

name = num2str(numberStr);

filename = pname;
filename(end-3:end)=[];
save([savePath name '\' 'GT_' filename '_' name '.mat'], 'resultData'); % save resultDataR
% warndlg('Done!','warning!');
close all
disp('----------------------done!-----------------------------')



