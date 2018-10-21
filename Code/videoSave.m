function  videoSave(file_name,video,frame_rate)
% videoSave Save an image sequence as video
%  Each image must be an RGB image

    v = VideoWriter(file_name);
    v.FrameRate = frame_rate;
    open(v);
    
    for k = 1:size(video,4)
        frame = video(:,:,:,k);
        writeVideo(v,frame);
    end
    
    close(v);
end

