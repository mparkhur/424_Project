function c = wavelet(data)

ls = liftwave('cdf2.2','Int2Int');
c = lwt2(double(data),ls);

end