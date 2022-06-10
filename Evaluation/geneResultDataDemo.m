% function resultData = geneResultData(srcData)
% generate resultData for cognition experiements.
% cut lines
% input: 
%       srcData: location of targets.
% output:
%       resultData: linkage of targets
%====================================================
close all
clc
clear all
addpath('./pics/')

%% -------enter your name------------
disp('Pls enter your name first!')
numberStr = 'subaba';

%% ---------------------------------------

button = 1;
w = 700; % should be 700; can be changed
h = 700; % should be 700
line_TRI = []; 
savePath = './Evaluation/pics/'; % save path


%%------get test image--------------



[pname,adrname]=uigetfile('E:\PandaSpaceSyn\WorkingSpace\Tolerance\ToleranceModel\Evaluation\pics\icon.bmp','Select Your Images'); %'*.jpg','*.bmp', '*bmp'
        if exist(strcat(adrname,pname), 'file')

            shape = imread(strcat(adrname,pname));
            f = figure;
            imshow(shape);
            
            [w,h,~] = size(shape);
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
TRI = delaunay(x, y);
[len_TRI, col] = size(TRI);
temp_TRI = [];

% get all location(index) of linked lines
for j = 1: col
    if j < col
        for i = 1: len_TRI
            temp_TRI(i, 1) = TRI(i, j);
            temp_TRI(i, 2) = TRI(i, j+1);       
        end 
        line_TRI = [line_TRI; temp_TRI];
        temp_TRI = []; 
    else 
        for i = 1: len_TRI
            temp_TRI(i, 1) = TRI(i, j);
            temp_TRI(i, 2) = TRI(i, 1);       
        end 
        line_TRI = [line_TRI; temp_TRI];
        temp_TRI = [];     
    end    
end
 src_line_TRI = line_TRI;
Screen_charactors= get(0);
Screen_Size = Screen_charactors.ScreenSize;
centerX = Screen_Size(1);
centerY = Screen_Size(2);
width = Screen_Size(3);
height = Screen_Size(4);

movegui(f,[width,1]);

while 1  % while click right, mouse respond stops
    x_col1 =h- x(line_TRI(:, 1));
    y_col1 = y(line_TRI(:, 1));
    x_col2 =h- x(line_TRI(:, 2));
    y_col2 = y(line_TRI(:, 2));
    close
    figure
    set(gcf,'position',[centerX,centerY,width,height])
    plot( [y_col1, y_col2],[x_col1,x_col2],'ro', 'Linewidth', 2); %plot
    hold on 
    for i = 1:length(x_col1)
        plot( [y_col1(i), y_col2(i)],[x_col1(i), x_col2(i)], 'b-', 'Linewidth', 1);
    end
    axis([0 dataSize(1) 0 dataSize(2)]);   
    [x_ms(1), y_ms(1), button] = ginput(1);

    if button == 3 % click right mouse key to complete mission (left:1,mid:2,right:3)
        hold off
        close 
        break;       
    else
        [x_ms(2), y_ms(2)] = ginput(1);
        % plot(x_ms, y_ms, 'r-', 'Linewidth', 2);
        
        x_ms = round(x_ms);
        y_ms = round(y_ms);
        
        x_msMax = max(x_ms(1), x_ms(2));
        x_msMin = min(x_ms(1), x_ms(2));
        y_msMax = max(y_ms(1), y_ms(2));
        y_msMin = min(y_ms(1), y_ms(2));
                
        k_ms = (y_ms(2) - y_ms(1)) / (x_ms(2) - x_ms(1) + eps);
        b_ms = (x_ms(2) * y_ms(1) - x_ms(1) * y_ms(2)) / (x_ms(2) - x_ms(1) + eps);

        for idx = 1:length(line_TRI(:,1))
            
            y1 = x_col1(idx);
            x1 = y_col1(idx);
            y2 = x_col2(idx);
            x2 = y_col2(idx);

            k = (y2 - y1) / (x2 - x1 + eps) ;
            b = (x2 * y1 - x1 * y2) / (x2 - x1 + eps);

            x_cross = round( (b_ms - b)/(k - k_ms + eps) ); % intersection points with the ith line
            y_cross = round( (b*k_ms - b_ms*k)/(k_ms - k + eps));

            if ~isempty(x_cross)               
                if ((x_cross <= x_msMax) && (x_cross >= x_msMin) && ...
                 (y_cross <= y_msMax) && (y_cross >= y_msMin))
                    if ((x_cross <= max(x1, x2)) && (x_cross >= min(x1, x2)) && ...
                    (y_cross <= max(y1, y2)) && (y_cross >= min(y1, y2)))

                        line_TRI(idx,:) = [0,0];
                        [~, row] = ismember([line_TRI(idx,2) line_TRI(idx,1)],line_TRI,'rows');
                        if row > 0 
                            line_TRI(row,:) = [0,0];
                        end
                    end
                end
            else
                continue;
            end
        end 
        ind_remove = find(line_TRI(:,1) ==  0);
        line_TRI(ind_remove,:) = [];

    end
end

resultData = line_TRI; % index of number, very small 
name = num2str(numberStr);


filename = pname;
filename(end-3:end)=[];
save([savePath  'GT_' filename '_' name '.mat'], 'resultData'); % save resultDataR
% warndlg('Done!','warning!');
close all
disp('----------------------done!-----------------------------')