function waveletTest

img = imread('test.bmp');

[c,s] = wavedec2(img,1,'haar');

[index, bins, count] = quantizeAndCount(c, 512);

cdq = dequantize(index, bins);

disp(max(c-cdq));

re_img = waverec2(cdq,s,'haar');

figure;
imshow(uint8(img));
figure;
imshow(uint8(re_img));
end