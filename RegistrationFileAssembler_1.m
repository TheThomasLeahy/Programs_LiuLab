%Code by Thomas Leahy

%This program draws your GOBJs for you!

clear all; close all; clc;

%% Load the files
foldername = uigetdir('/*', 'Select the folder containing the data (Must contain named folders within it, and a folder with the "Registration Files")');
files = dir(foldername);

%Doctor files (get rid of '.', '..', and '.DS_Store'
x = 1;
for i = 1:length(files)
    if ~strcmp(files(i).name, '.DS_Store') && ~strcmp(files(i).name, '.') ...
            && ~strcmp(files(i).name, '..') && ~strcmp(files(i).name, 'Registration Files')
        theseFiles(x) = files(i);
        x = x + 1;
    end
end

dl = '/';
if ispc
    dl = '\';
end

RegFolder = [foldername dl 'Registration Files'];
regFiles = dir(RegFolder);

x = 1;
for i = 1:length(regFiles)
    if ~strcmp(regFiles(i).name, '.DS_Store') && ~strcmp(regFiles(i).name, '.') ...
            && ~strcmp(regFiles(i).name, '..')
        regFiles2(x) = regFiles(i);
        x = x + 1;
    end
end

regFiles = regFiles2;

%{
if ~strcmp(foldername(1), 'C')
    %This is not in the C drive. We need to change drives.
    command = foldername(1:2);
    system(command);
end

strind = strfind(foldername, dl);

for i =1:length(strind)
    if i ~= length(strind)
        command = ['cd' ' ' foldername(strind(i)+1:strind(i+1)-1)];
        system(command);
    else
        command = ['cd' ' ' foldername(strind(i)+1:end)];
        system(command);
    end
end
%}

%% Rename the files (Get rid of the ";1"), Separate into Desired Folders, and Add the registration files to the folder

for j = 1:length(theseFiles)
    string = [foldername dl theseFiles(j).name];
    
    %command = ['cd' ' ' theseFiles(j).name];
    %dos(command);
    
    innerFiles = dir(string);
    
    x = 1;
    for i = 1:length(innerFiles)
        if ~strcmp(innerFiles(i).name, '.DS_Store') && ~strcmp(innerFiles(i).name, '.') ...
                && ~strcmp(innerFiles(i).name, '..')
            innerFiles2(x) = innerFiles(i);
            x = x + 1;
        end
    end
    
    innerFiles = innerFiles2;
    
    %Get rid of the ";1"
    for i = 1:length(innerFiles)
        filename = innerFiles(i).name;
        file = [foldername dl theseFiles(j).name dl filename];
        ind = strfind(filename, ';1');
        if ~isempty(ind)
            newname = filename(1:ind-1);
            newfile = [foldername dl theseFiles(j).name dl newname];
            movefile(file, newfile);
        end
    end
    
    %Separate into Desired Folders
    innerFiles = dir(string);
    
    x = 1;
    for i = 1:length(innerFiles)
        if ~strcmp(innerFiles(i).name, '.DS_Store') && ~strcmp(innerFiles(i).name, '.') ...
                && ~strcmp(innerFiles(i).name, '..')
            innerFiles2(x) = innerFiles(i);
            x = x + 1;
        end
    end
    
    innerFiles = innerFiles2;
    
    for i = 1:length(innerFiles)-1
        k = i + 1;
        name1 = innerFiles(i).name(4:8);
        name2 = innerFiles(k).name(4:8);
        newFolder = [foldername dl theseFiles(j).name dl name2 '-' name1];
        mkdir(newFolder);
        
        cd(newFolder);
        
        file1 = [foldername dl theseFiles(j).name dl innerFiles(i).name];
        file2 = [foldername dl theseFiles(j).name dl innerFiles(k).name];
        copyfile(file1, newFolder);
        copyfile(file2, newFolder);
        
        %Copy the Registration Files into each folder
        
        for z = 1:length(regFiles)
            name = [RegFolder dl regFiles(z).name];
            copyfile(name, newFolder);
        end
        
        %Do the aim 2 mhd conversion
        command= ['aim2mhd' ' ' innerFiles(i).name ' ' '2'];
        dos(command);
        
        command= ['aim2mhd' ' ' innerFiles(k).name ' ' '2'];
        dos(command);
        
        mhd1 = innerFiles(i).name;
        mhd1 = [mhd1(1:end-3) 'mhd'];
        command = ['thresholdimagefilter' ' ' mhd1 ' ' '3000'];
        dos(command);
        
        mhd2 = innerFiles(k).name;
        mhd2 = [mhd2(1:end-3) 'mhd'];
        command = ['thresholdimagefilter' ' ' mhd2 ' ' '3000'];
        dos(command);
        

    end
    
    for i = 1:length(innerFiles)
        filename = innerFiles(i).name;
        file = [foldername dl theseFiles(j).name dl filename];
        delete(file);
    end
    
end











