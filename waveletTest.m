function waveletTest

img = imread('test.bmp');

c = wavelet(img);

dim = size(c);

[index, bins, count] = quantizeAndCount(c, 128, true);

% Entropy Coding Here

cdq = dequantize(index, bins, true);

cdq = reshape(cdq, dim);

re_img = inverseWavelet(cdq);

figure;
subplot(1,2,1);
imshow(uint8(img));
subplot(1,2,2);
imshow(uint8(re_img));
end