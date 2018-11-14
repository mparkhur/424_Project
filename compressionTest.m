function compressionTest

[~,~] = mkdir('Test');
[~,~] = mkdir('Test/compression');

infile = 'foreman_qcif.y';

isLossy = false;
qBins = 64;

if (isLossy)
    outfile = sprintf('Test/compression/test_lossy%d.bit', qBins);
    videoName = sprintf('Test/compression/test_lossy%d.y', qBins);
else
    outfile = 'Test/compression/test_lossless.bit';
    videoName = 'Test/compression/test_lossless.y';
end

packetSize = [144 176 5];
blockSize = [8 8];

% Write the compressed file header
writeHeader(packetSize, blockSize, isLossy, qBins, outfile);

% Various Dimension Calculations
height = packetSize(1);
width = packetSize(2);

mvHeight = height/blockSize(1);
mvWidth = width/blockSize(2);
mvSize = [mvHeight mvWidth 2 packetSize(3)-1];

% Read One Frame Packet
packet = readFrameBlock(infile, packetSize, 1);
packet = double(packet);

% Allocate frame vector and motion vector vector
frames = zeros(packetSize);
mvs = zeros(mvSize);

% Insert the first frame into the frame vector
frame1 = wavelet(packet(:,:,1));
frames(:,:,1) = frame1;

% Calculate motion vectors and error frames
for j = 1:size(packet,3)-1
    mv = motionEstimation(packet(:,:,j), packet(:,:,(j+1)), blockSize(1), blockSize(2), 16);
    mcpr = motionError(packet(:,:,j), packet(:,:,(j+1)) ,mv);

    mcprt = wavelet(mcpr);
    
    frames (:,:,(j+1)) = mcprt;
    mvs(:,:,:,j) = mv;
end

framesv = reshape(frames, 1, []);
mvsv = reshape(mvs, 1, []);

[fIndex, minmax, fCounts] = quantizeAndCount(framesv, qBins, isLossy, false);
[mvIndex, ~, mvCounts] = quantizeAndCount(mvsv, 0, 0, true);

writeEncPacket(isLossy, fCounts, minmax, fIndex, mvCounts, mvIndex, outfile);

clearvars -except outfile videoName;

% Read compressed file header
[packetSize, blockSize, isLossy, numBins, bitsRead] = readHeader(outfile);

% Various Dimension Calculations
height = packetSize(1);
width = packetSize(2);

mvHeight = height/blockSize(1);
mvWidth = width/blockSize(2);
mvSize = [mvHeight mvWidth 2 packetSize(3)-1];

% Read in one packet
[minmax, qdata, qmvs, ~] = readDecPacket(outfile, isLossy, numBins, packetSize, mvSize, bitsRead);

% Dequantize data
framesdq = dequantize(qdata, minmax, isLossy, numBins, false);
mvsdq = dequantize(qmvs, 0, false, 0, true);

% Reshape frames and mvs
framesdq = reshape(framesdq, packetSize);
mvsdq = reshape(mvsdq, mvSize);

% Inverse Wavelet
for i=1:packetSize(3)
    framesdq(:,:,i) = inverseWavelet(framesdq(:,:,i));
end

% Motion Prediction
for j = 1:size(framesdq,3)-1
    mv = mvsdq(:,:,:,j);
    
    pred = motionPrediction(framesdq(:,:,j),mv);
    
    framesdq(:,:,(j+1)) = framesdq(:,:,(j+1)) + pred;
end

% Write to .y file
writeFrames(framesdq, videoName);

clear;

end

