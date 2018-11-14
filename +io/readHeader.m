function [packetDims, blockDims, isLossy, numBins, bytesRead] = readHeader(outfile)

% | frameHeight | frameWidth | packetLength | searchBlockHeight |
% searchBlockWidth | isLossy | (optional - numBins) |

packetDims = zeros(1,3);
blockDims = zeros(1,2);
numBins = 0;
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

% Lossy
isLossy = fread(fid, 1, 'uint8');
bytesRead = bytesRead + 1;

if isLossy
    numBins = fread(fid, 1, 'uint16');
    bytesRead = bytesRead + 2;
end

fclose(fid);

clearvars -except packetDims blockDims isLossy numBins bytesRead;

end