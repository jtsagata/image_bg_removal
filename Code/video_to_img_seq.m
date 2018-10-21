function video_to_img_seq(videoIn,fname)
%video_to_img_seq Save some frame from video in to an image file

frames = size(videoIn,4);
every_frame = floor(frames/9);

h = figure;
for k=1:9
    subplot(3,3,k);
    frame_no = k*every_frame;
    imshow( videoIn(:,:,:,frame_no));
    text_str = ['Frame: ' num2str(frame_no,'%4d') ];
    title(text_str);
end

saveas(gcf,fname)
close(h)
end

