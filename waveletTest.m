function waveletTest

import io.*;
import transform.*;
import quantize.*;

[~,~] = mkdir('Test');
[~,~] = mkdir('Test/wavelet');

%QCIF: [144 176 1];
%CIF: [288 352 1];
frameDim = [288 352 1];
img = readFrameBlock('foreman_cif.y', frameDim, 1);
img = img - 128;
wlevel = 3;

cdata = wavelet(img,wlevel);

dim = size(cdata);

numBins = 288;

bitfile = sprintf('Test/wavelet/test_wave_%dbin.bit', numBins);
outfile = sprintf('Test/wavelet/test_wave_%dbin.bmp', numBins);

%[index, min, counts] = quantizeAndCount(c, numBins, true, false);
[qdata,maxi,counts] = quantizeiFrame(cdata, numBins);

% Entropy Coding Here
enc_data = arithenco(qdata, counts);

outID = fopen(bitfile, 'wb');
fwrite(outID, length(qdata), 'uint32');
fwrite(outID, counts, 'uint32');
fwrite(outID, enc_data, 'ubit1');
fclose(outID);

cdq = arithdeco(enc_data, counts, length(qdata));

cdq = dequantizeiFrame(cdq, maxi, numBins, dim);

cdq = reshape(cdq, dim);

re_img = inverseWavelet(cdq, wlevel);
re_img = re_img + 128;
img = img + 128;

figure;
subplot(1,2,1);
imshow(uint8(img));
subplot(1,2,2);
imshow(uint8(re_img));

imwrite(uint8(re_img), outfile);
imwrite(uint8(img), 'original_frame.bmp');

end