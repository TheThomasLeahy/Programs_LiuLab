%Code by Thomas Leahy

%This program draws your GOBJs for you!

clear all; close all; clc;

%% Load the files
foldername = uigetdir('/*', 'Select the folder containing the data (Must only be the data)');
files = dir(foldername);

%Doctor files (get rid of '.', '..', and '.DS_Store'
x = 1;
for i = 1:length(files)
    if files(i).bytes ~= 0
        if ~strcmp(files(i).name, '.DS_Store')
            theseFiles(x) = files(i);
            x = x + 1;
        end
    end
end

dl = '/';
if ispc
    dl = '\';
end

%% Read the files

file = cell(1,length(theseFiles));
for i = 1:length(theseFiles)
    fileID = [foldername dl theseFiles(i).name];
    file{i} = imread(fileID);
end

%% Draw GOBJ

dim = size(file{1},1);

for i = 1:length(theseFiles)
    H{i} = gobjects(dim);
end





