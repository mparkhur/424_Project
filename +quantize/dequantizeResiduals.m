function data = dequantizeResiduals(qdata, maxi, numBins)

numBins = floor(numBins/2);

if (size(qdata,1)>1)
    qdata = reshape(qdata,1,[]);
end

if (mod(numBins,2)==0)
    numBins=numBins+1;
end

stepSize = ceil((maxi*2)/numBins);

qdata = qdata - ceil(numBins/2);

data = qdata.*stepSize;

clearvars -except data;

end