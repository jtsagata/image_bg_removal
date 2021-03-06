clearvars;
close all

% Load image sequence
load('../Data/cars.mat');
[height, width, frames]= size(ImSeq);

% CONTROL VARIABLES
threshold = 2.5;
alpha = 0.01;

frame_rate = 10;

% Lambda (acessible from cli also)
implay8 = @(V) implay(uint8(V), frame_rate);


%% START PROCESSING

% Estimate from first 'skip_frames' frames


% Calculate rest of frames
ImSeq_noBg = zeros([height, width, frames],'like',ImSeq);
ImSeq_meds = zeros([height, width, frames],'like',ImSeq);
ImSeq_vars = zeros([height, width, frames],'like',ImSeq);

% First Frame
var_mode = 1;
skip_frames = 3;
ImSeq_meds(:, :, 1) = ImSeq(:,:,1);
ImSeq_vars(:, :, 1) = var(ImSeq(:,:,1:skip_frames),var_mode,3);
% ImSeq_vars(:, :, 1) = 1;

for k=2:frames
    ImSeq_meds(:,:,k) = alpha .* ImSeq(:, :, k) + (1-alpha) .* ImSeq_meds(:,:,k-1);
    d_sq = abs( ImSeq(:, :, k) - ImSeq_meds(:,:,k)).^2 ;
    
    ImSeq_vars(:,:,k) = alpha .* d_sq  + (1-alpha) .* ImSeq_vars(:,:,k-1);
   
    crit = abs( (ImSeq(:,:,k) - ImSeq_meds(:,:,k)) ./ sqrt(ImSeq_vars(:,:,k)) );
    idx = crit > threshold;
    
    frame = zeros([height, width]);
    img = ImSeq(:, :, k);
    frame(idx)= img(idx);
    
    ImSeq_noBg(:,:,k) = frame;
end

%% RESULTS

% Show Video
implay8(ImSeq_noBg);
video_annot = anotate_video_box(uint8(ImSeq_noBg));
 
videoSave('../Videos/a3_gaussian.avi',video_annot,10);
video_to_img_seq(video_annot,'../Videos/a3_gaussian.png');