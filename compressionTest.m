function compressionTest

import io.*;
import transform.*;
import quantize.*;
import motion.*;

[~,~] = mkdir('Test');
[~,~] = mkdir('Test/compression');

infile = 'foreman_cif.y';
isCIF = true;

qBins = 100;
searchRange = 16;

outfile = sprintf('Test/compression/test_lossy%d_%s.bit', qBins, datestr(now,'yy-mm-dd(HH;MM)'));
videoName = sprintf('Test/compression/test_lossy%d_%s.y', qBins, datestr(now,'yy-mm-dd(HH;MM)'));

if (isCIF)
    packetSize = [288 352 5];
else
    packetSize = [144 176 5];
end
blockSize = [8 8];

% CIF can acheive better compression at 2 wavelet levels
% QCIF becomes too blurry at 2 levels
if (isCIF)
    waveletLevel = 2;
else
    waveletLevel = 1;
end

% Various Dimension Calculations
height = packetSize(1);
width = packetSize(2);
frameSize = [ height width ];

residualsSize = [ frameSize packetSize(3)-1 ];

mvHeight = height/blockSize(1);
mvWidth = width/blockSize(2);
mvSize = [mvHeight mvWidth 2 packetSize(3)-1];

%calculate the total number of packets
file = dir(infile);
num_packets = file.bytes/(prod(packetSize));

headerWritten = false;

gcp;

for i = 1:num_packets

    % Read One Frame Packet
    packet = readFrameBlock(infile, packetSize, i);
    packet = double(packet - 127);

    % Allocate frame vector and motion vector vector
    residuals = zeros(residualsSize);
    mvs = zeros(mvSize);

    % Insert the first frame into the frame vector
    iframe = wavelet(packet(:,:,1), waveletLevel);

    % Calculate motion vectors and error frames
    for j = 1:packetSize(3)-1
        mv = motionEstimation(packet(:,:,j), packet(:,:,(j+1)), blockSize(1), blockSize(2), searchRange);
        mcpr = motionError(packet(:,:,j), packet(:,:,(j+1)) ,mv);

        residuals(:,:,j) = wavelet(mcpr, waveletLevel);
        mvs(:,:,:,j) = mv;
    end
    
    % DCPM
    for k = packetSize(3)-1:-1:2
        residuals(:,:,k) = residuals(:,:,k) - residuals(:,:,k-1);
        mvs(:,:,:,k) = mvs(:,:,:,k) - mvs(:,:,:,k-1);
    end

    mcprsv = reshape(residuals, 1, []);
    mvsv = reshape(mvs, 1, []);

    [fIndex, fMax, fCounts] = quantizeiFrame(iframe, qBins);
    [rIndex, rMax] = quantizeResiduals(mcprsv, qBins);
    [mvIndex] = quantizeMVs(mvsv);
    
    if (headerWritten == false)
        rCounts = countResiduals(rIndex, qBins);
        mvCounts = countMVs(mvIndex);
        
        % Write the compressed file header
        writeHeader(packetSize, blockSize, qBins, rCounts, mvCounts, outfile);
        
        headerWritten = true;
    end
    
    writeEncPacket(fMax, fCounts, fIndex, rMax, rCounts, rIndex, mvCounts, mvIndex, outfile);

    disp("Encoded: " + i);
end

clearvars -except outfile videoName;

% Read compressed file header
[packetSize, blockSize, numBins, rCounts, mvCounts, bytesRead] = readHeader(outfile);

% Various Dimension Calculations
height = packetSize(1);
width = packetSize(2);
frameSize = [ height width ];

residualsSize = [ frameSize packetSize(3)-1 ];

mvHeight = height/blockSize(1);
mvWidth = width/blockSize(2);
mvSize = [ mvHeight mvWidth 2 packetSize(3)-1 ];

if (packetSize(1) == 288)
    waveletLevel = 2;
else
    waveletLevel = 1;
end

%calculate the total number of packets
file = dir(outfile);
totalBytes = file.bytes;

k = 1;
%START
while totalBytes > bytesRead
    % Read in one packet
    [fMax, qiframe, rMax, qresiduals, qmvs, bytesRead] = readDecPacket(outfile, numBins, packetSize, mvSize, rCounts, mvCounts, bytesRead);

    % Dequantize data
    iframe = dequantizeiFrame(qiframe, fMax, numBins, frameSize);
    residuals = dequantizeResiduals(qresiduals, rMax, numBins);
    mvs = dequantizeMVs(qmvs);

    % Reshape frames and mvs
    iframe = reshape(iframe, frameSize);
    residuals = reshape(residuals, residualsSize);
    mvs = reshape(mvs, mvSize);
    
    % Reverse DCPM
    for j = 2:packetSize(3)-1
        residuals(:,:,j) = residuals(:,:,j) + residuals(:,:,j-1);
        mvs(:,:,:,j) = mvs(:,:,:,j) + mvs(:,:,:,j-1);
    end

    % Inverse Wavelet
    iframe = inverseWavelet(iframe, waveletLevel);
    
    parfor i=1:residualsSize(3)
        residuals(:,:,i) = inverseWavelet(residuals(:,:,i), waveletLevel);
    end
    
    frames = zeros(packetSize);
    frames(:,:,1) = iframe;

    % Motion Prediction
    for j = 1:size(residuals,3)
        mv = mvs(:,:,:,j);

        pred = motionPrediction(frames(:,:,j),mv);

        frames(:,:,(j+1)) = residuals(:,:,j) + pred;
    end
    
    frames = frames + 127;

    % Write to .y file
    writeFrames(frames, videoName);
    
    disp("Decoded: " + k);
    k = k + 1;

end

clear;

end

