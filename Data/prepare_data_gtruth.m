%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VISUAL TRACKING
% ----------------------
% Background Subtraction
% ----------------
% Date: Octomber 2018
% Authors: Ioannis Tsagatakis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all


imPath = 'highway/groundtruth'; imExt = 'png';
SKIP_IMAGES=470;

% check if directory and files exist
if isdir(imPath) == 0
    error('USER ERROR : The image directory does not exist');
end

filearray = dir([imPath filesep '*.' imExt]); 
NumImages = size(filearray,1); 
if NumImages < 0
    error('No image in the directory');
end

disp('Loading image files from the video sequence, please be patient...');
% Get image parameters
imgname = [imPath filesep filearray(1).name]; % get image name
I = imread(imgname); % read the 1st image and pick its size
VIDEO_WIDTH = size(I,2);
VIDEO_HEIGHT = size(I,1);

ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, NumImages-SKIP_IMAGES);
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; % get image name
    if i >= SKIP_IMAGES
        ImSeq(:,:,i) = imread(imgname); % load image
    end
end
disp(' ... OK!');

gTruth = uint8(ImSeq);
save('gtruth.mat', 'gTruth','-v7.3');
disp(' Saving ... DONE!');
whos('-file','gtruth.mat')

