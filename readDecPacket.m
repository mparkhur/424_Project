function [minmax, data, mvs, bytesRead] = readDecPacket(outfile, isLossy, numBins, dataDims, mvDims, byteOffset)

% | minmax | (optional - countsLength) | totalDataBits | DataCounts |  DATA  | totalMVBits | mvCounts |  MVS  |
% | int16  |         uint16            |     uint32    |   uint16   |  ubit1 |    uint32   |  uint16  | ubit1 |

fid = fopen(outfile, 'rb');

% Move file pointer to relevant data
fseek(fid, byteOffset, 'bof');
bitsRead = byteOffset * 8;

% max or min (depends on lossy or lossless)
minmax = fread(fid, 1, 'bit16=>double');
bitsRead = bitsRead + 16;

% Length of Counts histogram
if ~isLossy
    lenCounts = fread(fid, 1, 'ubit16=>double');
    bitsRead = bitsRead + 16;
else
    if (mod(numBins,2)==0)
        numBins=numBins+1;
    end
    
    lenCounts = numBins;
end

% Total number of bits in Data
numBitsData = fread(fid, 1, 'ubit32=>double');
bitsRead = bitsRead + 32;

% Counts histogram
dataCounts = fread(fid, lenCounts, 'ubit18=>double');
bitsRead = bitsRead + lenCounts * 18;

% Data
enc_data = fread(fid, numBitsData, 'ubit1');
bitsRead = bitsRead + double(numBitsData);

% Total number of bits in mvs
numBitsMV = fread(fid, 1, 'ubit16=>double');
bitsRead = bitsRead + 16;

% MV Counts histogram
mvCounts = fread(fid, 33, 'ubit12=>double');
bitsRead = bitsRead + 33 * 12;

% MVs
enc_mvs = fread(fid, numBitsMV, 'ubit1');
bitsRead = bitsRead + numBitsMV;

fclose(fid);

bytesRead = ceil(bitsRead/8);

% Decode Data and mvs
data = arithdeco(enc_data, dataCounts, prod(dataDims));
mvs = arithdeco(enc_mvs, mvCounts, prod(mvDims));

clearvars -except minmax data mvs bytesRead;

end