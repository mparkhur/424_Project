function c = wavelet(data, level)

 % Level 1
 ls = liftwave('bior4.4');
 c = lwt2(double(data),ls);
 
 % Level 2
 if (level == 2)
    ca = c(1:2:end,1:2:end);
    ca = lwt2(ca,ls);
    c(1:2:end,1:2:end) = ca;
 end
 
%     figure;
%     img = c;
%     CA1 = img(1:2:end,1:2:end);
%     CH1 = img(2:2:end,1:2:end);
%     CV1 = img(1:2:end,2:2:end);
%     CD1 = img(2:2:end,2:2:end);
%     CA2 = CA1(1:2:end,1:2:end);
%     CH2 = CA1(2:2:end,1:2:end);
%     CV2 = CA1(1:2:end,2:2:end);
%     CD2 = CA1(2:2:end,2:2:end);
%     CA1 = [ CA2 CH2 ; CV2 CD2 ];
%     img = [ CA1 CH1 ; CV1 CD1 ];
%     imshow(uint8(img));
 
end
 