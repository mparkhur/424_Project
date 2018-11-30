function Encoder(infile, outfile, numBins, isCIF)

import io.* motion.* quantize.* transform.*;

searchRange = 16;

if (isCIF)
    packetSize = [288 352 5];
else
    packetSize = [144 176 5];
end
blockSize = [8 8];

waveletLevel = 3;

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
    [fIndex, fMax, fCounts] = quantizeiFrame(iframe, numBins);
    packet(:,:,1) = dequantizeiFrame(fIndex, fMax, numBins, frameSize);
    packet(:,:,1) = inverseWavelet(packet(:,:,1), waveletLevel);

    % Calculate motion vectors and error frames
    for j = 2:packetSize(3)  
        mv = motionEstimation(packet(:,:,j-1), packet(:,:,j), blockSize(1), blockSize(2), searchRange);
        mcpr = motionCompensation(packet(:,:,j-1), packet(:,:,j) ,mv);

        residuals(:,:,j-1) = wavelet(mcpr, waveletLevel);
        mvs(:,:,:,j-1) = mv;
        
        [index, imax] = quantizeResiduals(residuals(:,:,j-1), numBins);
        res = dequantizeResiduals(index, imax, numBins);
        res = inverseWavelet(res, waveletLevel);
        packet(:,:,j) = motionPrediction(packet(:,:,j-1), mv) + res;
    end
    
    % DPCM    
    for k = packetSize(3)-1:-1:2
        mvs(:,:,:,k) = mvs(:,:,:,k) - mvs(:,:,:,k-1);
    end

    mcprsv = reshape(residuals, 1, []);
    mvsv = reshape(mvs, 1, []);

    %[fIndex, fMax, fCounts] = quantizeiFrame(iframe, numBins);
    [rIndex, rMax] = quantizeResiduals(mcprsv, numBins);
    [mvIndex] = quantizeMVs(mvsv);
    
    if (headerWritten == false)
        rCounts = countResiduals(rIndex, numBins);
        mvCounts = countMVs(mvIndex);
        
        % Write the compressed file header
        writeHeader(packetSize, blockSize, numBins, rCounts, mvCounts, outfile);
        
        headerWritten = true;
    end
    
    writeEncPacket(fMax, fCounts, fIndex, rMax, rCounts, rIndex, mvCounts, mvIndex, outfile);

    disp("Encoded: " + i);
end

clear;

end

