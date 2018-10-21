function video_noBg = bgsub_frame_diff(ImSeq,skip_frames, threshold)
%bgsub_frame_diff Remove background using frame differencing method.
%    ImSeq: the image sequence
%    skip_frames: The fisrt frames used for averaging
%    threshold: The threshold for image to beleong to background
%  RETURNS:
%    The image sequence without the background

    bgAvg = median(ImSeq,skip_frames);
    video_noBg = zeros(size(ImSeq),'like',ImSeq);

    idx = abs(ImSeq - bgAvg)> threshold;
    video_noBg(idx) = ImSeq(idx);

end

