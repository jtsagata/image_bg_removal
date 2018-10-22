%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VISUAL TRACKING
% ----------------------
% Background Subtraction
% ----------------
% Date: september 2015
% Authors: You !!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all


%%%%% LOAD THE IMAGES
%=======================

% Give image directory and extension
imPath = 'car'; imExt = 'jpg';

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

ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, NumImages);
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; % get image name
    ImSeq(:,:,i) = imread(imgname); % load image
end
disp(' ... OK!');


% BACKGROUND SUBTRACTION
%=======================

% Describe here your background subtraction method

%bg10 = mean(ImSeq(:,:,1:10),3);
%imshow(bg10,[])

% DEFINE A BOUNDING BOX AROUND THE OBTAINED REGION
% you can draw the bounding box and show it on the image

video = ImSeq;
[height, width, frames]= size(video);

save('cars.mat', 'ImSeq');


