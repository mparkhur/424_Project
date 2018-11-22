function [qdata,maxi,counts] = quantizeiFrame(data, numBins)

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

counts = zeros(1,numBins);

for i=1:numel(qdata)
        counts(qdata(i)) = counts(qdata(i))+1;
end

counts=counts+1;

clearvars -except qdata maxi counts;

end