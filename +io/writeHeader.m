function writeHeader(packetDims, blockDims, numBins, rCounts, mvCounts, outfile)

fid = fopen(outfile, 'wb');

% Frame Packet Dimensions
fwrite(fid, packetDims(1), 'uint16');
fwrite(fid, packetDims(2), 'uint16');
fwrite(fid, packetDims(3), 'uint8');

% Search Block Dimensions
fwrite(fid, blockDims(1), 'uint8');
fwrite(fid, blockDims(2), 'uint8');

% Number of bins
fwrite(fid, numBins, 'uint16');

% Residual counts
fwrite(fid, rCounts, 'uint32');

% MV counts
fwrite(fid, mvCounts, 'uint16');

fclose(fid);

end