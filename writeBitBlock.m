function writeBitBlock(isLossy, counts, minmax, data, outfile)

% | minmax | (optional - countsLength) | totalDataBits | DATA |

if size(counts,1) > 1
    counts = reshape(counts, 1, []);
end

if size(data,1) > 1
    data = reshape(data, 1, []);
end

% max or min (depends on lossy or lossless)
fid = fopen(outfile, 'ab');
fwrite(fid, minmax, 'uint16');

% Length of Counts histogram
if ~isLossy
    fwrite(fid, numel(counts), 'uint16');
end

% Total number of bits in Data
fwrite(fid, numel(data), 'uint32');

% Counts histogram
fwrite(fid, counts, 'uint16');

% Data
fwrite(fid, data, 'ubit1');

fclose(fid);

end