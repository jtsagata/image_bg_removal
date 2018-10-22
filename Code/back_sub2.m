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
%bgAvg = movmean(ImSeq,3,3);
%nobag = zeros(size(I));
%for i=1:size(a,2)
    
%end

% For all images
Backgrounds = zeros(VIDEO_HEIGHT,VIDEO_WIDTH,NumImages);
for k = 1:NumImages
  Background = zeros(VIDEO_HEIGHT,VIDEO_WIDTH);
  for i = 1:VIDEO_HEIGHT
    for j = 1:VIDEO_WIDTH
        Background(i,j) = median(ImSeq(i,j,1:NumImages));
    end
  end
end


Background = zeros(VIDEO_HEIGHT,VIDEO_WIDTH);
ImSeq_noBG = zeros(VIDEO_HEIGHT,VIDEO_WIDTH,NumImages);
for i = 1:VIDEO_HEIGHT
    for j = 1:VIDEO_WIDTH
        val = median(ImSeq(i,j,1:NumImages));
        Background(i,j) = val;
    end
end



Threshhold = 50;
ImSeq_noBG = zeros(VIDEO_HEIGHT,VIDEO_WIDTH,NumImages);
for k = 1:NumImages
    for i = 1:VIDEO_HEIGHT
        for j = 1:VIDEO_WIDTH
            if abs(ImSeq(i,j,k)-Background(i,j)) > Threshhold
                ImSeq_noBG(i,j,k)= ImSeq(i,j,k);
            end
        end
    end
end

implay(uint8(ImSeq_noBG))     


% DEFINE A BOUNDING BOX AROUND THE OBTAINED REGION
% you can draw the bounding box and show it on the image





