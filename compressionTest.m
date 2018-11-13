function compressionTest

outfile = 'test_lossless.bit';
infile = 'foreman_qcif.y';

isLossy = false;
qBins = 256;

packetSize = [144 176 5];
blockSize = [8 8];

% Write the compressed file header
writeHeader(packetSize, blockSize, isLossy, qBins, outfile);

% Various Dimension Calculations
height = packetSize(1);
width = packetSize(2);
frameSize = height*width;

bHeight = height/blockSize(1);
bWidth = width/blockSize(2);
bSize = bHeight*bWidth*2;

% Read One Frame Packet
packet = readFrameBlock(infile, packetSize, 1);
packet = double(packet);

% Allocate frame vector and motion vector vector
framesv = zeros(1, frameSize*packetSize(3));
mvsv = zeros(1, bSize*(packetSize(3)-1));

% Insert the first frame into the frame vector
frame1 = wavelet(packet(:,:,1));
framesv(1:frameSize) = reshape(frame1, 1, []);

% Calculate motion vectors and error frames
for j = 1:size(packet,3)-1
    mv = motionEstimation(packet(:,:,j), packet(:,:,(j+1)), blockSize(1), blockSize(2), 16);
    mcpr = motionError(packet(:,:,j), packet(:,:,(j+1)) ,mv);

    %mvt(:,:,1) = wavelet(mv(:,:,1)); 
    %mvt(:,:,2) = wavelet(mv(:,:,2));
    mcprt = wavelet(mcpr);

    frstrt = j*frameSize+1;
    frend = frstrt+frameSize-1;
    framesv(frstrt:frend) = reshape(mcprt, 1, []);
    
    frstrt = (j-1)*bSize+1;
    frend = frstrt+bSize-1;
    mvsv(frstrt:frend) = reshape(mv, 1, []);
end

[fIndex, minmax, fCounts] = quantizeAndCount(framesv, qBins, isLossy, false);
[mvIndex, ~, mvCounts] = quantizeAndCount(mvsv, 0, 0, true);

writeEncPacket(isLossy, fCounts, minmax, fIndex, mvCounts, mvIndex, outfile);

clearvars -except outfile;

% Read compressed file header
[packetSize, blockSize, isLossy, numBins, bitsRead] = readHeader(outfile);

% Various Dimension Calculations
height = packetSize(1);
width = packetSize(2);

bHeight = height/blockSize(1);
bWidth = width/blockSize(2);
mvSize = [bHeight bWidth 2 packetSize(3)-1];

% Read in one packet
[minmax, fdata, mvs, ~] = readDecPacket(outfile, isLossy, numBins, packetSize, mvSize, bitsRead);

% Dequantize data
framesdq = dequantize(fdata, minmax, isLossy, numBins, false);
mvsdq = dequantize(mvs, 0, 0, 0, true);

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
    %mv(:,:,1) = inverseWavelet(mv(:,:,1));
    %mv(:,:,2) = inverseWavelet(mv(:,:,2));
    
    pred = motionPrediction(framesdq(:,:,j),mv);
    
    mcpr = framesdq(:,:,(j+1));
    mcpr = inverseWavelet(mcpr);
    
    framesdq(:,:,(j+1)) = pred + mcpr;
end

writeFrames(framesdq, 'test.y');

clear;

end

