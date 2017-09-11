%Code by Thomas Leahy

clear all; close all; clc;


%% Get Files

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

%% Write Document 
pathname = foldername;

formatSpec = '%s';
sizeA = [75 2];

file = cell(1,length(theseFiles));
for i = 1:length(theseFiles)
    fileID = [pathname dl theseFiles(i).name];
    file{i} = tdfread(fileID);
end

headers = fieldnames(file{1})';

data = cell(length(theseFiles), length(headers));
for i = 1:length(theseFiles)
   for j = 1:length(headers)
       string = ['file{' num2str(i) '}.' headers{j}];
       data{i,j} = eval(string);
       if size(data{i,j},1) > 1
           string = [string '(size(data{i,j},1),:)'];
           data{i,j} = eval(string);
       end
   end
end

finalArray = [headers; data];


filename = [pathname dl 'Datasheet.csv'];
xlswrite(filename,finalArray);

fclose('all');






    