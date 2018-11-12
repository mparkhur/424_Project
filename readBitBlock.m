function [counts, minmax, data, bitsRead] = readBitBlock(outfile, isLossy, numBins, bitOffset)

% | minmax | (optional - countsLength) | totalDataBits | DATA |

fid = fopen(outfile, 'rb');

% Move file pointer to relevant data
fread(fid, bitOffset, 'ubit1');
bitsRead = bitOffset;

% max or min (depends on lossy or lossless)
minmax = fread(fid, 1, 'uint16');
bitsRead = bitsRead + 16;

% Length of Counts histogram
if ~isLossy
    lenCounts = fread(fid, 1, 'uint16');
    bitsRead = bitsRead + 16;
else
    lenCounts = numBins;
end

% Total number of bits in Data
numBits = fread(fid, 1, 'uint32');
bitsRead = bitsRead + 16;

% Counts histogram
counts = fread(fid, lenCounts, 'uint16');
bitsRead = bitsRead + lenCounts * 16;

% Data
data = fread(fid, numBits, 'ubit1');
bitsRead = bitsRead + numBits;

fclose(fid);

end