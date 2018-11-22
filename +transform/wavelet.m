function c = wavelet(data)

 ls = liftwave('bior4.4');
 c = lwt2(double(data),ls);

end