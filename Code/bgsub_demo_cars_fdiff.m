clearvars;
close all

load('cars.mat');
video_noBg = bgsub_frame_diff(ImSeq, 3, 60);
video_annot = anotate_video_box(video_noBg);
videoSave('../Videos/bgsub_framediff_cars.avi',video_annot,10);