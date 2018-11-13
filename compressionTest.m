function compressionTest

outfile = 'test_lossy64.bit';
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

for j = 1:size(packet,3)-1
    mv = motionEstimation(packet(:,:,j), packet(:,:,(j+1)), blockSize(1), blockSize(2), 16);
    mcpr = motionError(packet(:,:,j), packet(:,:,(j+1)) ,mv);

    mvt(:,:,1) = wavelet(mv(:,:,1)); 
    mvt(:,:,2) = wavelet(mv(:,:,2));
    mcprt = wavelet(mcpr);

    blkv = [blkv reshape(mvt, 1, []) reshape(mcprt, 1, [])];
end

[index, minmax, counts] = quantizeAndCount(blkv, qBins, isLossy);

writeEncPacket(isLossy, counts, minmax, index, outfile);

clearvars -except outfile;

[packetSize, blockSize, isLossy, numBins, bitsRead] = readHeader(outfile);

height = packetSize(1);
width = packetSize(2);
frameSize = height*width;

bHeight = height/blockSize(1);
bWidth = width/blockSize(2);
bSize = bHeight*bWidth*2;

[minmax, data, ~] = readDecPacket(outfile, isLossy, numBins, bitsRead);

datadq = dequantize(data, minmax, isLossy, numBins);

frames = zeros(packetSize);
frames(:,:,1) = reshape(datadq(1:frameSize), height, width);
frames(:,:,1) = inverseWavelet(frames(:,:,1));
datadq = datadq(frameSize+1:end);

for j = 1:size(frames,3)-1
    
    mv = reshape(datadq(1:bSize), bHeight, bWidth, 2);
    mv(:,:,1) = inverseWavelet(mv(:,:,1));
    mv(:,:,2) = inverseWavelet(mv(:,:,2));
    datadq = datadq(bSize+1:end);
    
    pred = motionPrediction(frames(:,:,j),mv);
    
    mcpr = reshape(datadq(1:frameSize), height, width);
    mcpr = inverseWavelet(mcpr);
    
    frames(:,:,(j+1)) = pred + mcpr;
    datadq = datadq(frameSize+1:end);
end

writeFrames(frames, 'test.y');

clear;

end

