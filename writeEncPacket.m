function writeEncPacket(isLossy, dataCounts, minmax, data, mvCounts, mvs, outfile)

% | minmax | (optional - countsLength) | totalDataBits | DataCounts |  DATA  | totalMVBits | mvCounts |  MVS  |
% | int16  |         uint16            |     uint32    |   uint16   |  ubit1 |    uint32   |  uint16  | ubit1 |

if size(dataCounts,1) > 1
    dataCounts = reshape(dataCounts, 1, []);
end

if size(data,1) > 1
    data = reshape(data, 1, []);
end

% Encode Data and mvs
enc_data = arithenco(data, dataCounts);
enc_mvs = arithenco(mvs, mvCounts);

% max or min (depends on lossy or lossless)
fid = fopen(outfile, 'ab');
fwrite(fid, minmax, 'int16');

% Length of Counts histogram
if ~isLossy
    fwrite(fid, numel(dataCounts), 'ubit16');
end

% Total number of bits in Data
fwrite(fid, numel(enc_data), 'ubit32');

% Counts histogram
fwrite(fid, dataCounts, 'ubit16');

% Data
fwrite(fid, enc_data, 'ubit1');

% Total number of bits in mvs
fwrite(fid, numel(enc_mvs), 'ubit16');

% mvCounts histogram
fwrite(fid, mvCounts, 'ubit16');

% mvs
fwrite(fid, enc_mvs, 'ubit1');

fclose(fid);

clearvars;

end