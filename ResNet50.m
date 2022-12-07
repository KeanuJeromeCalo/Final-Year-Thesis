net = resnet50();

%configuring data store
pathToImages = "C:\Users\keanu\OneDrive\Desktop\tig_dataset","IncludeSubfolders";
ds = imageDatastore(pathToImages,"IncludeSubFolders",true,"LabelSource","foldernames");
classifications = ds.Labels;

[dsTrain,dsTest,dsValidation,dsTrash] = splitEachLabel(ds,1000,200,200,"randomized")
%[dsTrain,dsTest] = splitEachLabel(ds,0.8,"randomized");
numClasses = numel(categories(ds.Labels));

%get size of images
fname = ds.Files;
img = readimage(ds,8);
%imshow(img)
sz = size(img)

%get input size required by resnet
inlayer = net.Layers(1);
insz = inlayer.InputSize 

%augment weld_ds (resize)
aug = imageDataAugmenter('RandRotation',[-20,20],RandYReflection=true,RandXShear=[-20 20])
augdsTrain = augmentedImageDatastore([224 224],dsTrain,"ColorPreprocessing","gray2rgb","DataAugmentation",aug)
augdsTest = augmentedImageDatastore([224 224],dsTest,"ColorPreprocessing","gray2rgb")
augdsValidation = augmentedImageDatastore([224 224],dsValidation,"ColorPreprocessing","gray2rgb")

%img1 = readimage(ds,8);
%sz = size(img1)

%training options
opts = trainingOptions("sgdm","InitialLearnRate",0.001,"MiniBatchSize",32,"Plots","training-progress",ValidationData=augdsValidation)

%perform training
gpuDevice(1)
warning('on','nnet_cnn:warning:GPULowOnMemory')
[weldnet,info] = trainNetwork(augdsTrain, lgraph_1, opts);
%use trained network to classify test images
testpreds = classify(weldnet,augdsTest);

%plot training loss
plot(info.TrainingLoss)
%% 

%investigate test performance
testActual = dsTest.Labels;
numCorrect = nnz(testpreds == testActual)
fracCorrect = numCorrect/numel(testpreds)
cm = confusionchart(dsTest.Labels,testpreds)
cm.Title = 'Weld classification using ResNet-50'
%%
%DEEP DREAM
%analyzeNetwork(weldnet);
layer = 175;
channels = 1:6;
name = weldnet.Layers(layer).Name;
I = deepDreamImage(weldnet,name,channels,'Verbose',false,"NumIterations",20,'PyramidLevels',2);
figure
I = imtile(I,'ThumbnailSize',[224 224]);
imshow(I)
title(['Layer ',name,' Features'],'Interpreter','none')
%%
%GRADCAM
%test = read(augdsTest)

imageNo = 15
X = readimage(dsTest,imageNo);
X = imresize(X,[224 224]);
imshow(X)
cmap = jet(256);
X = ind2rgb(X, cmap);
label = testpreds(imageNo)
scoreMap = gradCAM(weldnet,X,label);
figure
imshow(X)
hold on
imagesc(scoreMap,'AlphaData',0.5)
colormap jet
title(label)


