clearvars;
close all

% Set this to a new Value
threshold = 60;

frame_rate = 10;
file_name = 'a2.avi';


% Lambda (acessible from cli also)
implay8 = @(V) implay(uint8(V), frame_rate);

% Load image sequence
load('cars.mat');
[height, width, frames]= size(ImSeq);


%% START PROCESSING
bgAvg = median(ImSeq,3);
video_noBg = zeros(size(ImSeq),'like',ImSeq);

idx = abs(ImSeq - bgAvg)> threshold;
video_noBg(idx) = ImSeq(idx);

%% BOUNDING BOX

% frame = video_noBg(:,:,25);
% frame_bw = im2bw(frame, 0.5);
% 
% 
% st = regionprops(frame_bw, 'BoundingBox', 'Area' );
% [maxArea, indexOfMax] = max([st.Area]);
% bb = st(indexOfMax).BoundingBox;
% 
% bb_frame=insertShape(frame,'rectangle',bb);
% imshow(bb_frame,[])


% Show Video
implay8(video_noBg);
videoSave('a1_frames.avi',video_noBg,frame_rate)

