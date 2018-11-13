function [minmax, data, bitsRead] = readDecPacket(outfile, isLossy, numBins, bitOffset)

% | minmax | (optional - countsLength) | numSymbols | totalDataBits |  DATA  |
% | int16  |         uint16            |   uint32   |     uint32    |  ubit1 |

fid = fopen(outfile, 'rb');

% Move file pointer to relevant data
fread(fid, bitOffset, 'ubit1');
bitsRead = bitOffset;

% max or min (depends on lossy or lossless)
minmax = fread(fid, 1, 'int16');
bitsRead = bitsRead + 16;

% Length of Counts histogram
if ~isLossy
    lenCounts = fread(fid, 1, 'uint16');
    bitsRead = bitsRead + 16;
else
    lenCounts = numBins;
end

% Total number of symbols in Data
numSymbols = fread(fid, 1, 'uint32');
bitsRead = bitsRead + 32;

% Total number of bits in Data
numBits = fread(fid, 1, 'uint32');
bitsRead = bitsRead + 32;

% Counts histogram
counts = fread(fid, lenCounts, 'uint16');
bitsRead = bitsRead + lenCounts * 16;

% Data
enc_data = fread(fid, numBits, 'ubit1');
data = arithdeco(enc_data, counts, numSymbols);
bitsRead = bitsRead + numBits;

fclose(fid);

clearvars -except minmax data bitsRead;

end