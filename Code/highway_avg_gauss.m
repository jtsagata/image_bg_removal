clearvars;
load('../Data/highway8.mat'); 
load('../Data/gtruth.mat');

close all

% Split into initial background estimation and work videos
skip_frames = 470;
first_frames = video(:,:,:,1:skip_frames-1);
video_frames = video(:,:,:,skip_frames:size(video,4));
gtruth_frames = gTruth(:,:,skip_frames:size(video,4));

% Storage for montage Video
[width,height,depth,frames]=size(video_frames);
video_montage = zeros([width*2,height*2,depth,frames],'uint8');

% Initial background
cur_bgr = median(double(first_frames),4);

% Parameters
threshold = 110;
alpha = 0.01;
im2bw_level = 0.1;
track_objects=6;
maxArea = 40;

max_frames = 100000;

s_TP=0; s_FP=0; s_FN=0;
for k=1:min(size(video_frames,4),max_frames)
    cur_img = double(video_frames(:,:,:,k));
    
    dist_mat = sqrt(sum((cur_img - cur_bgr).^2, 3));
    is_onBG= (dist_mat>threshold);
    % Improve results a bit
    is_onBG=imfill(is_onBG,'holes');
    
    new_frame_noBG = cur_img .* is_onBG;
    
    curr_bgr_upd = new_frame_noBG .* alpha + cur_bgr .* (1-alpha);
    cur_bgr = cur_bgr .* not(is_onBG) + curr_bgr_upd .* is_onBG;
    
    % Calculate Confusion matrix
    curr_gtruth = imbinarize(gtruth_frames(:,:,k));
    m1=uint8(curr_gtruth(:));
    m2=uint8(is_onBG(:));
    
    %cm = confusionmat(m1,m2);
    TP = sum(bsxfun(@(a,b) a==1 & b==1, m1, m2));
    FP = sum(bsxfun(@(a,b) a==1 & b==0, m1, m2));
    FN = sum(bsxfun(@(a,b) a==0 & b==1, m1, m2));
    s_TP= s_TP+TP; s_FP= s_FP+FP; s_FN= s_FN+FN;
    PREC= TP/(TP+FP);
    REC = TP/(TP+FN);
    
            
    % get the bounding boxes
    im_bw = imbinarize(rgb2gray(new_frame_noBG), im2bw_level);
    st = regionprops(im_bw, 'BoundingBox', 'Area' );
    
    color_frame = uint8(cur_img);
    [maxAreas, indexOfMaxes] = maxk([st.Area],track_objects);
    for ob=1:min(track_objects, size(st,1))
        if  st(indexOfMaxes(ob)).Area > maxArea
            bb = st(indexOfMaxes(ob)).BoundingBox;
            % Add the bounding box
            color_frame=insertShape(color_frame,'rectangle',bb, 'LineWidth', 2, 'Color', 'red');
            new_frame_noBG=insertShape(uint8(new_frame_noBG),'rectangle',bb, 'LineWidth', 2, 'Color', 'red');
        end
    end

    % Add a frame number
    text_str = ['Frame: ' num2str(k+skip_frames,'%4d') ];
    cur_img = insertText(uint8(cur_img), [5,25], text_str, 'AnchorPoint','LeftBottom','TextColor','red');
    text_str_stat = ['Prec: ' num2str(PREC,3) ' Rec: ' num2str(REC, 3) ];
    cur_img = insertText(cur_img, [5,230], text_str_stat, 'AnchorPoint','LeftBottom','TextColor','red');

    % Montage
    video_montage(:,:,:,k) = [cur_img, new_frame_noBG; cur_bgr, color_frame];


end

h=implay(video_montage);
h.Parent.Position = [100 100 700 550];

T_PREC= s_TP/(s_TP+s_FP);
T_REC = s_TP/(s_TP+s_FN);
T_FSCORE = 2 * T_PREC * T_REC / (T_PREC + T_REC);

fileID = fopen('../Videos/highway_frame_diff.txt','w');
fprintf(fileID,'Precision: %1.4f\n',T_PREC);
fprintf(fileID,'Recall:    %1.4f\n',T_REC);
fprintf(fileID,'F-Score:   %1.4f\n',T_FSCORE);
fclose(fileID);



videoSave('../Videos/highway_frame_diff.avi',video_montage,10);
video_to_img_seq(video_montage,'../Videos/highway_frame_diff.png');