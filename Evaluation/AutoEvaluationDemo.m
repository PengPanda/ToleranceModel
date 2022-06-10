% demo-evaluation
close all
clear
addpath('./pics/');
addpath('./ppdata/')
addpath('./RDGdata/')

FileName = './F-scores.xlsx';
[NUM,TXT,RAW]=xlsread(FileName);

%% get the algorithm's result data
% [pname,adrname]=
% Sdata = load('RDG.mat');
pp=1;

[w,h] = size(RAW);
for i = 1:w
    dataNameStr = cell2mat(RAW(i,2));
    if i<14
        nameStr = [dataNameStr, '_1'];
    else
        nameStr = [dataNameStr, '_2'];
    end
    
    dataName = ['./ppdata/myData/', nameStr, '.mat'];
    Sdata = load(dataName);
    % Sdata = load(uigetfile('./evaluation/ppdata/', 'mat'));
    if pp == 1;
        try
            S = Sdata.resDataList;
        catch
            S = Sdata.clnList;
        end
    else
        S = Sdata.reserve_TRI;
    end
    %% get human-labeled data files
    % dicPath = uigetdir('./evaluation/pics/data/', 'choose your HumanLabeled data file!');
    dicPath = ['./pics/data/', dataNameStr];
    files = dir([dicPath, '/*.mat']);
    number_files = length(files);

    Plist = [];
    Rlist = [];
    Flist = [];

    if number_files > 0
        for j  = 1:number_files
            fileName = files(j).name; 
            GTdata = load([dicPath,'/', fileName]);

            GT= GTdata.resultData;
            [P,R,F] = PRevaluation(S,GT);

            Plist = [Plist, P];
            Rlist = [Rlist, R];
            Flist = [Flist, F];
        end  
    else 
        warndlg('No image input','warning !');
        return;
    end

    avgPrecision = mean(Plist);
    avgRecall = mean(Rlist);
    avgFscore = mean(Flist);
%     Flist
    ARRAY=[Flist,Flist];
    RANGE = ['D', int2str(i+2),':' 'H',int2str(i+2)];

    xlswrite(FileName,ARRAY,RANGE);
end
disp('-------done-----')