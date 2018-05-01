function trainImages()

%load data
%unzip('MerchData.zip');
images = imageDatastore('3d_irisDatasets',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

[trainingImages,validationImages] = splitEachLabel(images,0.5,'randomized');

numTrainImages = numel(trainingImages.Labels);
idx = randperm(numTrainImages,16);
%figure
for i = 1:16
    %subplot(4,4,i)
    I = readimage(trainingImages,idx(i));
    %imshow(I)
end

%load pretain network
net = alexnet;
%display the network architecture
net.Layers;

%tranfer layer to new network
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(trainingImages.Labels))
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%train network
miniBatchSize = 10;
numIterationsPerEpoch = floor(numel(trainingImages.Labels)/miniBatchSize);
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,...
    'MaxEpochs',4,...
    'InitialLearnRate',1e-4,...
    'Verbose',false,...
    'Plots','training-progress',...
    'ValidationData',validationImages,...
    'ValidationFrequency',numIterationsPerEpoch);

netTransfer = trainNetwork(trainingImages,layers,options);

%Classify the validation images
predictedLabels = classify(netTransfer,validationImages);
%display
idx = [1 5 10 15];
%figure
for i = 1:numel(idx)
    %subplot(2,2,i)
    I = readimage(validationImages,idx(i));
    label = predictedLabels(idx(i));
    %imshow(I)
    %title(char(label))
end
valLabels = validationImages.Labels;
accuracy = mean(predictedLabels == valLabels)

save('trainImage.mat','netTransfer');
end