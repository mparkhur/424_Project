function [qdata,maxi] = quantizeResiduals(data, numBins)

numBins = floor(numBins/2);

if (size(data,1)>1)
    data = reshape(data,1,[]);
end

if (mod(numBins,2)==0)
    numBins=numBins+1;
end

absd = abs(data);
maxi = ceil(max(absd));

stepSize = ceil((maxi*2)/numBins);

qdata = sign(data).*floor(absd/stepSize);

qdata = qdata + ceil(numBins/2);

clearvars -except qdata maxi;

end