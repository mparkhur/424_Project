function [packetDims, blockDims, isLossy, numBins, bitsRead] = readHeader(outfile)

% | frameHeight | frameWidth | packetLength | searchBlockHeight |
% searchBlockWidth | isLossy | (optional - numBins) |

packetDims = zeros(1,3);
blockDims = zeros(1,2);
numBins = 0;
bitsRead = 0;

fid = fopen(outfile, 'rb');

% Frame Packet Dimensions
packetDims(1) = fread(fid, 1, 'uint16');
bitsRead = bitsRead + 16;

packetDims(2) = fread(fid, 1, 'uint16');
bitsRead = bitsRead + 16;

packetDims(3) = fread(fid, 1, 'uint8');
bitsRead = bitsRead + 8;

% Search Block Dimensions
blockDims(1) = fread(fid, 1, 'uint8');
bitsRead = bitsRead + 8;

blockDims(2) = fread(fid, 1, 'uint8');
bitsRead = bitsRead + 8;

% Lossy
isLossy = fread(fid, 1, 'ubit1');
bitsRead = bitsRead + 1;

if isLossy
    numBins = fread(fid, 1, 'uint16');
    bitsRead = bitsRead + 16;
end

fclose(fid);

end