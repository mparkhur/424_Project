function idata = inverseWavelet(data, level)

 ls = liftwave('bior4.4');
 idata = ilwt2(data,ls,level);
 
end