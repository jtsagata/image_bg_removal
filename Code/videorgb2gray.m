function videoOut = videorgb2gray(videoIn)

    [width,height,tmp,frames] = size(videoIn);
    videoOut = zeros([width,height,frames],'uint8');

    for k=1:size(videoIn,4)
        frame = videoIn(:,:,:,k);
        R = frame(:,:,1);
        G = frame(:,:,2);
        B = frame(:,:,1);
        videoOut(:,:,k) = 1/3 * (R+G+B);
    end

end

