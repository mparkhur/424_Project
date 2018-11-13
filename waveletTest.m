function waveletTest

img = imread('test.bmp');

c = wavelet(img);

dim = size(c);

numBins = 48;
isLossy = true;

[index, min, counts] = quantizeAndCount(c, numBins, isLossy);

% Entropy Coding Here
enc_data = arithenco(index, counts);

outID = fopen('wave_encoding.bit', 'wb');
fwrite(outID, length(index), 'uint32');
fwrite(outID, counts, 'uint16');
fwrite(outID, enc_data, 'ubit1');
fclose(outID);

cdq = arithdeco(enc_data, counts, length(index));

cdq = dequantize(cdq, min, isLossy, numBins);

cdq = reshape(cdq, dim);

re_img = inverseWavelet(cdq);

figure;
subplot(1,2,1);
imshow(uint8(img));
subplot(1,2,2);
imshow(uint8(re_img));

imwrite(uint8(re_img), 'test_wave.bmp');

end