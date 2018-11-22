function idata = inverseWavelet(data)

 ls = liftwave('bior4.4');
 idata = ilwt2(data,ls);

end