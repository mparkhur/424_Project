function [] = CustomVideoCompression(infile, bitfile, outfile)

v = VideoReader('foreman.MP4');

%encode each frame  
while hasFrame(v)    
    frame = readFrame(v);
    [img,map] = rgb2ind(frame,256);
    
    %encode the video frame
    enc_frame = encode(img, bitfile);
    
    %read encoded frame from file
    %
    
    %decode the frame
    dec_frame = Decode(enc_frame, bitfile);
    
    %write the decoded frame to a new file
    %writeVideo(newVideo, dec_frame);
    
end


writeVideo();

end

