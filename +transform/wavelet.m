function c = wavelet(data, level)

 w = 'bior4.4';
 opt = 'gbl'; % Global threshold
 thr = 10;    % Threshold
 sorh = 'h';  % Hard thresholding
 keepapp = 1; % Approximation coefficients cannot be thresholded

 ls = liftwave(w);
 c = lwt2(double(data),ls,level);
 
 % Threshold Coefficients
 [c,~,~,~,~] = wdencmp(opt,c,w,level,thr,sorh,keepapp);
 
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
 