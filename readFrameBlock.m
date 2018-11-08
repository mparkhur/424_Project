function block = readFrameBlock(infile, blockDims, frameOffset)

height = blockDims(1);
width = blockDims(2);
depth = blockDims(3);

frameSize = height*width;
index = frameSize*(frameOffset - 1);

fid = fopen(infile, 'rb');
fread(fid, index, 'uint8');
block = fread(fid, (frameSize*depth), 'uint8');
fclose(fid);

block = reshape(block, width, height, depth);
block = permute(block, [2 1 3]);
block = double(block);

clearvars -except block;

end