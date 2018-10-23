clearvars;
close all

% Load image sequence
load('../Data/cars.mat');

% Trick to works with bw and color images
% https://stackoverflow.com/questions/19955653/matlab-last-dimension-access-on-ndimensions-matrix
otherdims = repmat({':'},1,ndims(ImSeq)-1);


% Resize Video
%   The SVD matrix is very large and bigger than
%    my computer memory
scale =0.5;
s = size(ImSeq);
video_small=zeros([floor(s(1:end-1)*scale) s(end)]);
for k=1:size(ImSeq,ndims(ImSeq))
    video_small(otherdims{:},k) = imresize(ImSeq(otherdims{:},k), scale);
end
frames=size(video_small,ndims(video_small));

% Calculate the mean vector
mean_vector = reshape(mean(video_small,ndims(video_small)) ,[] ,1);

% Calculate X matrix
videoAsCols = reshape(video_small,[],frames);
videoAsCols_norm = videoAsCols - repmat(mean_vector,1, frames);

% SVD
[U,~,~]=svd(videoAsCols_norm);

% Get first ratio columns as eigen background
keep_cols = 10;
Uk=U(:,1:keep_cols);
Uk_t=transpose(Uk);
clear 'U'

video_noBg = zeros(size(video_small));
threshold =  20;

for k=1:frames
    curr_frame = video_small(otherdims{:},k);
    curr_frame_vec = reshape(curr_frame,[],1);
    p = Uk_t * (curr_frame_vec-mean_vector);
    y = Uk*p + mean_vector;
    
    background=reshape(y,size(curr_frame));
    dif = abs(background-curr_frame); 
    idx = dif > threshold;
    
    new_frame = zeros(size(curr_frame));
    new_frame(idx) = curr_frame(idx); 

    video_noBg(otherdims{:},k)= new_frame;
    %video_noBg(otherdims{:},k)= background;
end



%implay8(ImSeq_noBg);
video_annot = anotate_video_box(uint8(video_noBg));
 
videoSave('../Videos/a5_eigen.avi',video_annot,10);
video_to_img_seq(video_annot,'../Videos/a5_eigen.png');