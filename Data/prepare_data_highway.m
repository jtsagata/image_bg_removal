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


%%%%% LOAD THE IMAGES
%=======================

% Give image directory and extension
imPath = 'highway/input'; imExt = 'jpg';
colorDepth = 3;

% check if directory and files exist
if isdir(imPath) == 0
    error('USER ERROR : The image directory does not exist');
end

filearray = dir([imPath filesep '*.' imExt]); % get all files in the directory
NumImages = size(filearray,1); % get the number of images
if NumImages < 0
    error('No image in the directory');
end

disp('Loading image files from the video sequence, please be patient...');
% Get image parameters
imgname = [imPath filesep filearray(1).name]; % get image name
I = imread(imgname); % read the 1st image and pick its size
VIDEO_WIDTH = size(I,2);
VIDEO_HEIGHT = size(I,1);

ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, colorDepth, NumImages);
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; % get image name
    ImSeq(:,:,:,i) = imread(imgname); % load image
end
disp(' ... OK!');

save('highway.mat', 'ImSeq','-v7.3');
disp(' Saving ... DONE!');
whos('-file','highway.mat')

