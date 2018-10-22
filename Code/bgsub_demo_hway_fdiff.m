%clearvars;
close all
load('../Data/highway.mat');
skip_frames = 470;
threshold = 60;
alpha = 0.05;

video_gray=videorgb2gray(ImSeq);
[width,height,frames]=size(video_gray);

% Estimate background from the first 'skip_frames' frames
first_frames = video_gray(:,:,1:skip_frames-1);
current_background = median(first_frames,3);
clear 'first_frames';

next_frames  = video_gray(:,:,skip_frames:frames);

% Results in BW
video_noBg   = zeros(size(next_frames),'uint8');
video_BgOnly = zeros(size(next_frames),'uint8');

% Results in RGB
video_boxes = zeros([width,height,3,frames],'uint8');
video_boxes_bg_only = zeros([width,height,3,frames],'uint8');


for k=1:size(video_noBg,3)
    cur_img = next_frames(:,:,k);
    new_frame_bw = zeros(size(cur_img), 'uint8');
    
    % Calculate current frame
    idx = abs(cur_img - current_background)> threshold;
    new_frame_bw(idx)= cur_img(idx);
    
    % Update background
    current_background(idx) = new_frame_bw(idx) .* alpha + current_background(idx) .* (1-alpha);
    
    % get the bounding boxes
    im2bw_level = 0.5;
    im_bw = imbinarize(new_frame_bw, im2bw_level);
    st = regionprops(im_bw, 'BoundingBox', 'Area' );

    color_frame = uint8(ImSeq(:,:,:,k+skip_frames-1));
    bw_frame = cat(3, new_frame_bw, new_frame_bw, new_frame_bw);
    % get n first larger objects
    track_objects=3;
    [maxAreas, indexOfMaxes] = maxk([st.Area],track_objects);
    for ob=1:min(track_objects, size(st,1))
        bb = st(indexOfMaxes(ob)).BoundingBox;
        % Add the bounding box
        color_frame=insertShape(color_frame,'rectangle',bb, 'LineWidth', 2, 'Color', 'red');
        bw_frame=insertShape(bw_frame,'rectangle',bb, 'LineWidth', 2, 'Color', 'red');
    end

    % Update Videos
    video_noBg(:,:,k) = new_frame_bw;
    video_BgOnly(:,:,k) = current_background;
    video_boxes(:,:,:,k) = color_frame;
    video_boxes_bg_only(:,:,:,k) = bw_frame;
end

implay(video_boxes)

return


%video_annot = anotate_video_box(video_noBg);

return
% Add the Box
st = regionprops(grayImage, 'BoundingBox', 'Area' );
[maxArea, indexOfMax] = max([st.Area]);
bb = st(indexOfMax).BoundingBox;
bb_frame=insertShape(rgbImage,'rectangle',bb);
        
% Add a frame number
text_str = ['Frame: ' num2str(k,'%4d') ];
rgbImage = insertText(bb_frame, [5,25], text_str, 'AnchorPoint','LeftBottom','TextColor','red');



%videoSave('../Videos/bgsub_framediff_highway.avi',video_annot,10);
%video_to_img_seq(video_annot,'../Videos/bgsub_framediff_highway.png');