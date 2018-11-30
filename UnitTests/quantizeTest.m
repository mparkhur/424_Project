function quantizeTest

import io.*;
import quantize.*;
import transform.*;

[~,~] = mkdir('Test');
[~,~] = mkdir('Test/quantize');

frameDim = [144 176 1];

x = linspace(0,1,256)'; 
map = [x x x];

blk = readFrameBlock('foreman_qcif.y', frameDim, 1);

name = sprintf('Test/quantize/frame%d.bmp', 1);
frame = blk(:,:,1);
imwrite(uint8(frame),map,name,'BMP');

frame = wavelet(blk(:,:,1));

[qdata,maxi,~] = quantizeiFrame(frame, 64);

data = dequantizeiFrame(qdata, maxi, 64);

blk = reshape(data, 144, 176);

blk = inverseWavelet(blk);

name = sprintf('Test/quantize/dqframe%d.bmp', 1);
frame = blk(:,:,1);
imwrite(uint8(frame),map,name,'BMP');


clearvars;

end