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

imds.ReadFcn = @customReadDatastoreImage;

% plotting bar charts of label categories
bar(labelCount.Count)
set(gca,'xticklabel',labelCount.Label)

%Specify Training and Validation Sets
% splitEachLabel splits the imds image datastore into 3 new datastores;
% training set, test set and validation set
[imdsTrain,imdsValidation, imdsTest] = splitEachLabel(imds,7000,950,1000, 'Randomized');


function imds = customReadDatastoreImage(filename)
% code from default function: 
onState = warning('off', 'backtrace'); 
c = onCleanup(@() warning(onState)); 
imds = imread(filename); % added lines: 
imds = imds(:,:,min(1:3, end)); 
imds = imresize(imds,[28 28]);
imds =im2gray(imds);
end