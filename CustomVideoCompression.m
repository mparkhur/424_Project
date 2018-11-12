function [] = CustomVideoCompression(infile, bitfile, outfile)

isLossy = false;
qBins = 256;

packageSize = [144 176 5];

writeHeader(packageSize, isLossy, qBins, outfile);

f = dir(infile);
totalFrames = f.Bytes / (packageSize(1)*packageSize(2));

for i = 1:packageSize(3):totalFrames
    
    if (i + packageSize(3) > totalFrames)
        packageSize(3) = totalFrames - i + 1;
    end
    
    block = readFrameBlock(infile, packageSize, i);
    
    blkt = wavelet(block(:,:,1));
    blkv = reshape(blkt, 1, []);
    
    for j = 2:length(block)
        mv = motionEstimation(prev, curr, blkx, blky, search_range);
        mcpr = motionPrediction(prev,curr,mv);
        
        mvt(:,:,1) = wavelet(mv(:,:,1)); 
        mvt(:,:,2) = wavelet(mv(:,:,2));
        mcprt = wavelet(mcpr);
        
        blkv = [blkv reshape(mvt, 1, []) reshape(mcprt, 1, [])];
    end
    
    [index, ~, counts] = quantizeAndCount(blkv, qBins, isLossy);
    
    appendBits(numel(counts), outfile)
    appendBits(index, outfile);
    
end

% v = VideoReader('foreman.MP4');
% 
% %encode each frame  
% while hasFrame(v)    
%     frame = readFrame(v);
%     [img,map] = rgb2ind(frame,256);
%     
%     %encode the video frame
%     enc_frame = encode(img, bitfile);
%     
%     %read encoded frame from file
%     %
%     
%     %decode the frame
%     dec_frame = Decode(enc_frame, bitfile);
%     
%     %write the decoded frame to a new file
%     %writeVideo(newVideo, dec_frame);
%     
% end
% 
% 
% writeVideo();

end

