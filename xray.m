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

% Define the convolutional neural network architecture.
layers = [
imageInputLayer([28 28 1])
convolution2dLayer(3,8,'Padding','same')
batchNormalizationLayer
reluLayer
maxPooling2dLayer(2,'Stride',2)
convolution2dLayer(3,16 ...
,'Padding','same')
batchNormalizationLayer
reluLayer
maxPooling2dLayer(2,'Stride',2)
convolution2dLayer(3,32,'Padding','same')
batchNormalizationLayer
reluLayer
fullyConnectedLayer(6)
softmaxLayer
classificationLayer]


% Specify Training Options
options = trainingOptions('sgdm', ...
 'InitialLearnRate',0.001, ...
 'MaxEpochs',4, ...
 'Shuffle','every-epoch', ...
 'ValidationData',imdsValidation, ...
 'ValidationFrequency',30, ...
 'Verbose',false, ...
 'Plots','training-progress');

%Train Network Using Training Data
net = trainNetwork(imdsTrain,layers,options);


% Calculate test accuracy
YPredTest = classify(net,imdsTest);
YTest = imdsTest;
accuracyTest = sum(YPredTest == YTest.Labels)/numel(YTest.Labels)

% Compute validation accuracy
YPred = classify(net,imdsValidation);
YValidation = imdsValidation;
accuracyVal = sum(YPred == YValidation.Labels)/numel(YValidation.Labels)

% Plotting confusion matrix
plotconfusion(YTest.Labels,YPredTest)

function imds = customReadDatastoreImage(filename)
% code from default function: 
onState = warning('off', 'backtrace'); 
c = onCleanup(@() warning(onState)); 
imds = imread(filename); % added lines: 
imds = imds(:,:,min(1:3, end)); 
imds = imresize(imds,[28 28]);
imds =im2gray(imds);
end
