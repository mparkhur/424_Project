function writeEncPacket(isLossy, counts, minmax, data, outfile)

% | minmax | (optional - countsLength) | numSymbols | totalDataBits |  DATA  |
% | int16  |         uint16            |   uint32   |     uint32    |  ubit1 |

if size(counts,1) > 1
    counts = reshape(counts, 1, []);
end

if size(data,1) > 1
    data = reshape(data, 1, []);
end

% max or min (depends on lossy or lossless)
fid = fopen(outfile, 'ab');
fwrite(fid, minmax, 'int16');

% Length of Counts histogram
if ~isLossy
    fwrite(fid, numel(counts), 'uint16');
end

% Total number of symbols in Data
fwrite(fid, numel(data), 'uint32');

% Encode Data
enc_data = arithenco(data, counts);

% Total number of bits in Data
fwrite(fid, numel(enc_data), 'uint32');

% Counts histogram
fwrite(fid, counts, 'uint16');

% Data
fwrite(fid, enc_data, 'ubit1');

fclose(fid);

clearvars;

end