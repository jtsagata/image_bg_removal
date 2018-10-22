function outVideo = anotate_video(inVideo)
%anotate_video Add Frame number to a sequence of images
%   This will always return a color RGB image

    width = size(inVideo,1);
    height = size(inVideo,2);

    if size(size(inVideo),2) == 3 
        monochrome=true;
        frames = size(inVideo,3);
    else
        monochrome=false;
        frames = size(inVideo,4);
    end

    outVideo = zeros(width,height,3,frames);
    
    
    for k = 1:frames
        if monochrome
            grayImage = inVideo(:,:,k);
            rgbImage = cat(3, mat2gray(grayImage), mat2gray(grayImage), mat2gray(grayImage));
        else
            rgbImage = inVideo(:,:,k);
        end
        
        % Add a frame number
        text_str = ['Frame: ' num2str(k,'%4d') ];
        rgbImage = insertText(rgbImage, [5,25], text_str, 'AnchorPoint','LeftBottom','TextColor','red');
        
        outVideo(:,:,:,k) = rgbImage;
    end
    
end

