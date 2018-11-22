function compressionTest

import io.*;
import transform.*;
import quantize.*;
import motion.*;

[~,~] = mkdir('Test');
[~,~] = mkdir('Test/compression');

infile = 'foreman_qcif.y';

isLossy = true;
qBins = 64;
searchRange = 16;

if (isLossy)
    outfile = sprintf('Test/compression/test_lossy%d.bit', qBins);
    videoName = sprintf('Test/compression/test_lossy%d_%s.y', qBins, datestr(now,'yy-mm-dd(HH;MM)'));
else
    outfile = 'Test/compression/test_lossless.bit';
    videoName = sprintf('Test/compression/test_lossless_%s.y', datestr(now,'yy-mm-dd(HH;MM)'));
end

packetSize = [144 176 5];
blockSize = [8 8];

% Various Dimension Calculations
height = packetSize(1);
width = packetSize(2);

mvHeight = height/blockSize(1);
mvWidth = width/blockSize(2);
mvSize = [mvHeight mvWidth 2 packetSize(3)-1];

%calculate the total number of packets
file = dir(infile);
num_packets = file.bytes/(prod(packetSize));

gcp;

for i = 1:num_packets

    % Read One Frame Packet
    packet = readFrameBlock(infile, packetSize, i);
    packet = double(packet - 128);

    % Allocate frame vector and motion vector vector
    frames = zeros(packetSize);
    mvs = zeros(mvSize);

    % Insert the first frame into the frame vector
    frame1 = wavelet(packet(:,:,1));
    frames(:,:,1) = frame1;

    % Calculate motion vectors and error frames
    for j = 1:size(packet,3)-1
        mv = motionEstimation(packet(:,:,j), packet(:,:,(j+1)), blockSize(1), blockSize(2), searchRange);
        mcpr = motionError(packet(:,:,j), packet(:,:,(j+1)) ,mv);

        mcprt = wavelet(mcpr);

        frames (:,:,(j+1)) = mcprt;
        mvs(:,:,:,j) = mv;
    end

    iframev = reshape(frames(:,:,1), 1, []);
    mcprsv = reshape(frames(:,:,2:end), 1, []);
    mvsv = reshape(mvs, 1, []);

    [fIndex, fMax, fCounts] = quantizeiFrame(iframev, qBins);
    [rIndex, rMax] = quantizeResiduals(mcprsv, qBins);
    [mvIndex] = quantizeMVs(mvsv);
    
    if (i == 1)
        rCounts = countResiduals(rIndex, qBins);
        mvCounts = countMVs(mvIndex);
        
        % Write the compressed file header
        writeHeader(packetSize, blockSize, qBins, rCounts, mvCounts, outfile);
    end
    
    writeEncPacket(fMax, fCounts, fIndex, rMax, rCounts, rIndex, mvCounts, mvIndex, outfile);
    
%     figure;
%     for x = 1:5
%         img = frames(:,:,x);
%         CA = img(1:2:end,1:2:end);
%         CH = img(2:2:end,1:2:end);
%         CV = img(1:2:end,2:2:end);
%         CD = img(2:2:end,2:2:end);
%         img = [ CA CH ; CV CD ];
%         subplot(2,5,x);
%         imshow(uint8(img));
%     end
%     
%     for x = 1:5
%         img = inverseWavelet(frames(:,:,x));
%         subplot(2,5,x+5);
%         imshow(uint8(img));
%     end

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
mvSize = [mvHeight mvWidth 2 packetSize(3)-1];

%calculate the total number of packets
file = dir(outfile);
totalBytes = file.bytes;

k = 1;
%START
while totalBytes > bytesRead
    % Read in one packet
    [fMax, qiframe, rMax, qresiduals, qmvs, bytesRead] = readDecPacket(outfile, numBins, packetSize, mvSize, rCounts, mvCounts, bytesRead);

    % Dequantize data
    iframe = dequantizeiFrame(qiframe, fMax, numBins);
    residuals = dequantizeResiduals(qresiduals, rMax, numBins);
    mvs = dequantizeMVs(qmvs);

    % Reshape frames and mvs
    iframe = reshape(iframe, frameSize);
    residuals = reshape(residuals, residualsSize);
    mvs = reshape(mvs, mvSize);

    % Inverse Wavelet
    iframe = inverseWavelet(iframe);
    
    parfor i=1:residualsSize(3)
        residuals(:,:,i) = inverseWavelet(residuals(:,:,i));
    end
    
    frames = zeros(packetSize);
    frames(:,:,1) = iframe;

    % Motion Prediction
    for j = 1:size(residuals,3)
        mv = mvs(:,:,:,j);

        pred = motionPrediction(frames(:,:,j),mv);

        frames(:,:,(j+1)) = residuals(:,:,j) + pred;
    end
    
    frames = frames + 128;

    % Write to .y file
    writeFrames(frames, videoName);
    
    disp("Decoded: " + k);
    k = k + 1;

end

clear;

end

