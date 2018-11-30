function psnrMPEG

import io.*;
import transform.*;
import quantize.*;

frameDim = [288 352 1];
numBins = 192;

infile  = sprintf('foreman_cif.y');
outfile = sprintf('thr_test_%d.y', numBins);

MSE = zeros(1,25);
PSNR = zeros(1,25);

for i = 1:25
    in_img = readFrameBlock(infile, frameDim, i);
    out_img = readFrameBlock(outfile, frameDim, i);
    MSE(i) = sum((in_img - out_img).^2, 'all' )/numel(in_img);
    PSNR(i) = 10*log10(65025/MSE(i));
end

t_MSE = sum(MSE)/numel(MSE);
t_PSNR = sum(PSNR)/numel(PSNR);

disp(t_MSE);
disp(t_PSNR);