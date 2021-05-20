%Close all open figures
close all
%Clear the workspace
clear
%Clear the command window
clc

% load the X-Ray dataset as an image datastore
imds = imageDatastore('medicalmnist', 'IncludeSubfolders', true, 'LabelSource','foldernames')

% Counting the number of images in the dataset
noOfImagesTotal = size(imds.Labels)

