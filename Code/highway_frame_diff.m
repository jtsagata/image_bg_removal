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

% Storage for output Videos
video_noBg   = zeros(size(video_frames),'uint8');
video_BgOnly = zeros(size(video_frames),'uint8');
video_Boxes = zeros(size(video_frames),'uint8');


% Storage for montage Video
[width,height,depth,frames]=size(video_frames);
montage = zeros([width*2,height*2,depth,frames],'uint8');

% Initial background
cur_bgr = median(first_frames,4);

threshold = 60;
alpha = 0.05;

max_frames = 500;
for k=1:min(size(video_frames,4),max_frames)
    cur_img = video_frames(:,:,:,k);
    new_frame_noBG = zeros(size(cur_img), 'uint8');
    
    img_diff=rgb2gray(abs(cur_img - current_background));
    img_diff=rgb2gray(abs(current_background-cur_img));
    idx = img_diff > threshold;
    idx3 = cat(3,idx,idx,idx);
    new_frame_noBG(idx3)= cur_img(idx3);

%     for ix=1:size(cur_img,1)
%         for iy=1:size(cur_img,2)
%             v1 = single([cur_img(ix,iy,1),cur_img(ix,iy,2), cur_img(ix,iy,3)]);
%             v2 = single([cur_bgr(ix,iy,1),cur_bgr(ix,iy,2), cur_bgr(ix,iy,3)]);
%             dist = norm(v1-v2, 2); % 2nd order metric (Euclidian)
%             if dist>threshold
%                 new_frame_noBG(ix,iy,:)=cur_img(ix,iy,:);
%             end
%         end
%     end

    % Update background
    cur_bgr(idx3) = new_frame_noBG(idx3) .* alpha + cur_bgr(idx3) .* (1-alpha);

    % get the bounding boxes
    im2bw_level = 0.1;
    im_bw = imbinarize(rgb2gray(new_frame_noBG), im2bw_level);
    st = regionprops(im_bw, 'BoundingBox', 'Area' );
    
    color_frame = cur_img;
    
    % Update Videos
    video_noBg(:,:,:,k) = new_frame_noBG;
    video_BgOnly(:,:,:,k) = current_background;
    % Montage
    montage(:,:,:,k) = [cur_img, new_frame_noBG; cur_bgr, cur_bgr];
end

h=implay(montage);
h.Parent.Position = [100 100 700 550];

return

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