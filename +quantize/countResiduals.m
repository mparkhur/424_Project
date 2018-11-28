function counts = countResiduals(qdata, numBins)

numBins = floor(numBins/4);

if (mod(numBins,2)==0)
    numBins=numBins+1;
end

counts = zeros(1,numBins);

for i=1:numel(qdata)
        counts(qdata(i)) = counts(qdata(i))+1;
end

counts=counts+1;

clearvars -except counts;

end