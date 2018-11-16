function packet = readFrameBlock(infile, packetDims, frameOffset)

height = packetDims(1);
width = packetDims(2); 
depth = packetDims(3);

packetSize = prod(packetDims);
index = packetSize*(frameOffset - 1);

fid = fopen(infile, 'rb');
fseek(fid, index, 'bof');
packet = fread(fid, packetSize, 'uint8');
fclose(fid);

packet = reshape(packet, width, height, depth);
packet = permute(packet, [2 1 3]);
packet = double(packet);

clearvars -except packet;

end