function idata = inverseWavelet(data)

ls = liftwave('cdf2.2','Int2Int');
idata = ilwt2(data,ls);

end