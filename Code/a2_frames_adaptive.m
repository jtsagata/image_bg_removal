clearvars;
close all

% CONTROL VARIABLES
threshold = 50;
alpha = 0.05;
skip_frames = 10;
frame_rate = 10;

% Lambda (acessible from cli also)
implay8 = @(V) implay(uint8(V), frame_rate);

% Load image sequence
load('cars.mat');
[height, width, frames]= size(ImSeq);

%% START PROCESSING

% calculate background from first 'skip_frames' frames
curr_bg = median(ImSeq(:,:,1:skip_frames),3);

% Calculate rest of frames
ImSeq_noBg = zeros([height, width, frames-skip_frames],'like',ImSeq);
ImSeq_Bg = zeros([height, width, frames-skip_frames],'like',ImSeq);

for k=1:frames-skip_frames
    img = ImSeq(:, :, k+skip_frames);
    frame = zeros(size(img), 'like', img);
    
    % Calculate current frame
    idx = abs(img - curr_bg)> threshold;
    frame(idx)= img(idx);
    ImSeq_noBg(:,:,k) = frame;
    
    % Update background
    curr_bg(idx) = img(idx) .* alpha + curr_bg(idx) .* (1-alpha);
    
    ImSeq_Bg(:,:,k) = curr_bg;
end

%% RESULTS

% Show Video
implay8(ImSeq_noBg);
videoSave('a2_adaptive.avi',ImSeq_noBg,frame_rate)
videoSave('a2_adaptive_bg.avi',ImSeq_Bg,frame_rate)
