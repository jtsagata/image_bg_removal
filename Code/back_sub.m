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
bgAvg = movmean(ImSeq,3,3);
%nobag = zeros(size(I));
%for i=1:size(a,2)
    
%end
Background = zeros(VIDEO_HEIGHT,VIDEO_WIDTH);
for i = 1:VIDEO_HEIGHT
    for j = 1:VIDEO_WIDTH
        val = median(ImSeq(i,j,1:NumImages));
        Background(i,j) = val;
    end
end

Threshhold = 50;
alpha = 0.005;
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

% implay(uint8(ImSeq_noBG))     


BG_est = zeros(VIDEO_HEIGHT,VIDEO_WIDTH,NumImages);
BG_est(:,:,1) = Background;
for k = 2:NumImages
    for i = 1:VIDEO_HEIGHT
        for j = 1:VIDEO_WIDTH
            if abs(ImSeq(i,j,k)-Background(i,j)) > Threshhold
                BG_est(i,j,k) = alpha * ImSeq(i,j,k) + (1-alpha) * BG_est(i,j,k-1);
            else
                BG_est(i,j,k) =  BG_est(i,j,k-1);
            end
        end
    end
end

%implay(uint8(BG_est))     
ImSeq_noBG2 = zeros(VIDEO_HEIGHT,VIDEO_WIDTH,NumImages);
for k = 1:NumImages
    for i = 1:VIDEO_HEIGHT
        for j = 1:VIDEO_WIDTH
            if abs(ImSeq(i,j,k)-BG_est(i,j)) > Threshhold
                ImSeq_noBG2(i,j,k)= ImSeq(i,j,k);
            end
        end
    end
end

implay(uint8(ImSeq_noBG2))  

% DEFINE A BOUNDING BOX AROUND THE OBTAINED REGION
% you can draw the bounding box and show it on the image





