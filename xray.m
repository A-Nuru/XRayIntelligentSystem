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

% Counting the number of labels in each classes in the dataset
labelCount = countEachLabel(imds)

% Display some of the images in the datastore.
figure;
perm = randperm(6820,20); for i = 1:9
subplot(4,4,i); imshow(imds.Files{perm(i)});
end