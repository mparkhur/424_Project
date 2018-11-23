function [packetDims, blockDims, numBins, rCounts, mvCounts, bytesRead] = readHeader(outfile)

packetDims = zeros(1,3);
blockDims = zeros(1,2);
bytesRead = 0;

fid = fopen(outfile, 'rb');

% Frame Packet Dimensions
packetDims(1) = fread(fid, 1, 'uint16');
bytesRead = bytesRead + 2;

packetDims(2) = fread(fid, 1, 'uint16');
bytesRead = bytesRead + 2;

packetDims(3) = fread(fid, 1, 'uint8');
bytesRead = bytesRead + 1;

% Search Block Dimensions
blockDims(1) = fread(fid, 1, 'uint8');
bytesRead = bytesRead + 1;

blockDims(2) = fread(fid, 1, 'uint8');
bytesRead = bytesRead + 1;

% Number of bins
numBins = fread(fid, 1, 'uint16');
bytesRead = bytesRead + 2;

rBins = ceil(numBins/2);

% Always an odd number of bins
if (mod(rBins,2)==0)
    rBins=rBins+1;
end

% Residual counts
rCounts = fread(fid, rBins, 'uint32');
bytesRead = bytesRead + (rBins * 4);

% MV counts
mvCounts = fread(fid, 65, 'uint16');
bytesRead = bytesRead + (65 * 2);

fclose(fid);

clearvars -except packetDims blockDims numBins rCounts mvCounts bytesRead;

end