function calcPSNR

import io.*;
import transform.*;
import quantize.*;

[~,~] = mkdir('Test');
[~,~] = mkdir('Test/wavelet');

numBins = 224;

bitfile = sprintf('Test/wavelet/test_wave_%dbin.bit', numBins);
outfile = sprintf('Test/wavelet/test_wave_%dbin.bmp', numBins);

original = imread('original_frame.bmp');
decoded = imread(outfile);

MSE = sum((original - decoded).^2, 'all')/numel(original);
PSNR = 10*log10(65025/MSE);

bitfile = dir(bitfile);
bitsize = bitfile.bytes;

disp(bitsize);
disp(bitsize/102454);
disp(MSE);
disp(PSNR);

end

