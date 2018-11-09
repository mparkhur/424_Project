function waveletTest

img = imread('test.bmp');

c = wavelet(img);

dim = size(c);

[index, bins, counts] = quantizeAndCount(c, 256, true);

% Entropy Coding Here
save('histogram', 'counts');
Nbits = encArith(index, 'histogram', 'enc_wave.bit');
cdq = decArith('histogram', 'enc_wave.bit');

cdq = dequantize(cdq, bins, true);

cdq = reshape(cdq, dim);

re_img = inverseWavelet(cdq);

figure;
subplot(1,2,1);
imshow(uint8(img));
subplot(1,2,2);
imshow(uint8(re_img));
end