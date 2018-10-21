%clearvars;
close all
%clear all
%load('../Data/highway8.mat'); 

% Load video and convert to uint8, save result
% load('../Data/highway.mat'); 
% video = uint8(ImSeq);
% clear 'ImSeq';
% save('../Data/highway8.mat','video','-v7.3');



% Split into initial background estimation and work videos
skip_frames = 470;
first_frames = video(:,:,:,1:skip_frames-1);
video_frames = video(:,:,:,skip_frames:size(video,4));

% Storage for montage Video
[width,height,depth,frames]=size(video_frames);
montage = zeros([width*2,height*2,depth,frames],'uint8');

% Initial background
cur_bgr = median(first_frames,4);

threshold = 60;
alpha = 0.05;

max_frames = 5000;
for k=1:min(size(video_frames,4),max_frames)
    cur_img = video_frames(:,:,:,k);
    new_frame_noBG = zeros(size(cur_img), 'uint8');
    
    img_diff=rgb2gray(abs(current_background-cur_img));
    idx = img_diff > threshold;
    idx3 = cat(3,idx,idx,idx);
    new_frame_noBG(idx3)= cur_img(idx3);

    % Update background
    cur_bgr(idx3) = new_frame_noBG(idx3) .* alpha + cur_bgr(idx3) .* (1-alpha);

    % get the bounding boxes
    im2bw_level = 0.1;
    im_bw = imbinarize(rgb2gray(new_frame_noBG), im2bw_level);
    st = regionprops(im_bw, 'BoundingBox', 'Area' );
    
    color_frame = cur_img;
    track_objects=3;
    maxArea = 40;
    [maxAreas, indexOfMaxes] = maxk([st.Area],track_objects);
    for ob=1:min(track_objects, size(st,1))
        if  st(indexOfMaxes(ob)).Area > maxArea
            bb = st(indexOfMaxes(ob)).BoundingBox;
            % Add the bounding box
            color_frame=insertShape(color_frame,'rectangle',bb, 'LineWidth', 2, 'Color', 'red');
            new_frame_noBG=insertShape(new_frame_noBG,'rectangle',bb, 'LineWidth', 2, 'Color', 'red');
        end
    end
    
    % Add a frame number
    text_str = ['Frame: ' num2str(k+skip_frames,'%4d') ];
    cur_img = insertText(cur_img, [5,25], text_str, 'AnchorPoint','LeftBottom','TextColor','red');
    
    % Montage
    montage(:,:,:,k) = [cur_img, new_frame_noBG; cur_bgr, color_frame];
end

h=implay(montage);
h.Parent.Position = [100 100 700 550];

videoSave('../Videos/highway_frame_diff.avi',montage,10);
video_to_img_seq(montage,'../Videos/highway_frame_diff.png');