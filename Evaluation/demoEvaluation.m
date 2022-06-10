% demo-evaluation
close all
clear
addpath('./pics/');
addpath('./ppdata/')
addpath('./RDGdata/')

%% get the algorithm's result data
% [pname,adrname]=
% Sdata = load('RDG.mat');
pp=1;
Sdata = load(uigetfile('./evaluation/ppdata/', 'mat'));
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
dicPath = uigetdir('./evaluation/pics/data/', 'choose your HumanLabeled data file!');
files = dir([dicPath,'\*.mat']);
number_files = length(files);

Plist = [];
Rlist = [];
Flist = [];

if number_files > 0
    for i = 1:number_files
        fileName = files(i).name; 
        GTdata = load([dicPath '\' fileName]);
        
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
Flist