function writeHeader(packetDims, blockDims, isLossy, numBins, outfile)

% | frameHeight | frameWidth | packetLength | searchBlockHeight |
% searchBlockWidth | isLossy | (optional - numBins) |

fid = fopen(outfile, 'wb');
% Frame Packet Dimensions
fwrite(fid, packetDims(1), 'uint16');
fwrite(fid, packetDims(2), 'uint16');
fwrite(fid, packetDims(3), 'uint8');

% Search Block Dimensions
fwrite(fid, blockDims(1), 'uint8');
fwrite(fid, blockDims(2), 'uint8');

% Lossy
fwrite(fid, uint8(isLossy)*128, 'ubit1');

if isLossy
    fwrite(fid, numBins, 'uint16');
end

fclose(fid);

end