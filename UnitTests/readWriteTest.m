function readWriteTest

import io.*;

[~,~] = mkdir('Test');
[~,~] = mkdir('Test/readWrite');

outfile = sprintf('Test/readWrite/frames_%s.y', datestr(now,'yy-mm-dd(HH;MM)'));
frameDim = [144 176 5];

blk = readFrameBlock('foreman_qcif.y', frameDim, 1);

writeFrames(blk, outfile);

blk = readFrameBlock(outfile, frameDim, 1);

x = linspace(0,1,256)'; 
map = [x x x];

for i = 1:size(blk, 3)
    name = sprintf('Test/readWrite/frame%d.bmp', i);
    frame = blk(:,:,i);
    imwrite(uint8(frame),map,name,'BMP');
end

clearvars;

end