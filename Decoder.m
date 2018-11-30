function Decoder(infile, outfile)

import io.* motion.* quantize.* transform.*;

% Read compressed file header
[packetSize, blockSize, numBins, rCounts, mvCounts, bytesRead] = readHeader(infile);

% Various Dimension Calculations
height = packetSize(1);
width = packetSize(2);
frameSize = [ height width ];

residualsSize = [ frameSize packetSize(3)-1 ];

mvHeight = height/blockSize(1);
mvWidth = width/blockSize(2);
mvSize = [ mvHeight mvWidth 2 packetSize(3)-1 ];

waveletLevel = 3;

%calculate the total number of packets
file = dir(infile);
totalBytes = file.bytes;

% Overwrite .y file
fid = fopen(outfile, 'w');
fclose(fid);

k = 1;
%START
while totalBytes > bytesRead
    % Read in one packet
    [fMax, qiframe, rMax, qresiduals, qmvs, bytesRead] = readDecPacket(infile, numBins, packetSize, mvSize, rCounts, mvCounts, bytesRead);

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
    writeFrames(frames, outfile);
    
    disp("Decoded: " + k);
    k = k + 1;

end

clear;

end

