net = resnet18();

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
sz = size(img);

%get input size required by resnet
inlayer = net.Layers(1);
insz = inlayer.InputSize;

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
[weldnet18,info18] = trainNetwork(augdsTrain, lgraph_2, opts);
%use trained network to classify test images
testpreds18 = classify(weldnet18,augdsTest);

%plot training loss
%plot(info18.TrainingLoss)
%% 

%investigate test performance with confusion chart
testActual = dsTest.Labels;
numCorrect18 = nnz(testpreds18 == testActual)
fracCorrect18 = numCorrect18/numel(testpreds18)
cm18 = confusionchart(dsTest.Labels,testpreds18)
cm18.Title = 'Weld classification using ResNet-18'
%% 

%analyzeNetwork(weldnet18);
layer = 2;
name = weldnet18.Layers(layer).Name
channels = 1:6;
I = deepDreamImage(weldnet18,name,channels,"PyramidLevels",1);
figure
I = imtile(I,'ThumbnailSize',[64 64]);
imshow(I)
title(['Layer ',name,' Features'],'Interpreter','none')
%% 
%weldnet18.Layers(end).Classes(channels)
layer = 2;
channels = 1:6;
I = deepDreamImage(weldnet18,name,channels,'Verbose',false,"NumIterations",20,'PyramidLevels',2);
figure
I = imtile(I,'ThumbnailSize',[224 224]);
imshow(I)
name = weldnet18.Layers(layer).Name;
title(['Layer ',name,' Features'],'Interpreter','none')

%% 

layer = 69;
channels = 1:6;
I = deepDreamImage(weldnet18,name,channels,'Verbose',false,"NumIterations",100,'PyramidLevels',2);
figure
I = imtile(I,'ThumbnailSize',[224 224]);
imshow(I)
name = weldnet18.Layers(layer).Name;
title(['Layer ',name,' Features'])
%%
%GRADCAM
%test = read(augdsTest)

imageNo = 90
X = readimage(dsTest,imageNo);
X = imresize(X,[224 224]);
imshow(X)
cmap = jet(256);
X = ind2rgb(X, cmap);
label = testpreds(imageNo)
scoreMap = gradCAM(weldnet18,X,label);
figure
imshow(X)
hold on
imagesc(scoreMap,'AlphaData',0.5)
colormap jet
title(label)

