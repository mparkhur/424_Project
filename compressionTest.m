function compressionTest

outfile = 'test.bit';
infile = 'foreman_qcif.y';

isLossy = false;
qBins = 256;

packetSize = [144 176 5];
blockSize = [8 8];

writeHeader(packetSize, blockSize, isLossy, qBins, outfile);

packet = readFrameBlock(infile, packetSize, 1);
packet = double(packet);

blkt = wavelet(packet(:,:,1));
blkv = reshape(blkt, 1, []);

for j = 2:size(packet,3)-1
    mv = motionEstimation(packet(:,:,j), packet(:,:,(j+1)), blockSize(1), blockSize(2), 16);
    mcpr = motionError(packet(:,:,j), packet(:,:,(j+1)) ,mv);

    mvt(:,:,1) = wavelet(mv(:,:,1)); 
    mvt(:,:,2) = wavelet(mv(:,:,2));
    mcprt = wavelet(mcpr);

    blkv = [blkv reshape(mvt, 1, []) reshape(mcprt, 1, [])];
end

[index, minmax, counts] = quantizeAndCount(blkv, qBins, isLossy);

% Encode Here

writeBitBlock(isLossy, counts, minmax, index, outfile);

clearvars -except outfile;

[packetSize, blockSize, isLossy, numBins, bitsRead] = readHeader(outfile);

height = packetSize(1);
width = packetSize(2);
frameSize = height*width;

bHeight = blockSize(1);
bWidth = blockSize(2);
bSize = bHeight*bWidth*2;

[counts, minmax, data, ~] = readBitBlock(outfile, isLossy, numBins, bitsRead);

% Decode Here

datadq = dequantize(data, minmax, isLossy, numBins);

frames = zeros(packetSize);
frames(:,:,1) = resize(datadq(1:frameSize), height, width);
datadq = datadq(frameSize:end);

for j = 2:length(frames)
    
    mv = resize(datadq(1:bSize), bHeight, bWidth, 2);
    datadq = datadq(bSize:end);
    
    pred = motionPrediction(prev,curr,mv);
    
    frames(:,:,j) = pred + resize(datadq(1:frameSize), height, width);
    datadq = datadq(frameSize:end);
end

writeFrames(frames, 'test.y');

end

