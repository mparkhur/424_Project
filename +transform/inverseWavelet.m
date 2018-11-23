function idata = inverseWavelet(data, level)

 ls = liftwave('bior4.4');
 
 % Level 2
 if (level == 2)
    ca = data(1:2:end,1:2:end);
    ca = ilwt2(ca,ls);
    data(1:2:end,1:2:end) = ca;
 end

 % Level 1
 idata = ilwt2(data,ls);
 
end