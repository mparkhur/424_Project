function [index,bins,counts] = quantizeAndCount(data, numBins)

if (mod(numBins, 2) == 0)
    numBins = numBins + 1;
end

bins = linspace(-1,1,numBins+2)*512;
bins = bins(bins~=0);

index = quantiz(reshape(data,1,[]), bins);
index = index+1;

counts = zeros(1,numel(bins)-1);

for i=1:numel(index)
    counts(index(i)) = counts(index(i))+1;
end

counts=counts+1;

end