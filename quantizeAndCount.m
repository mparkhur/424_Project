function [index,bins,counts] = quantizeAndCount(data, numBins, isLossy)

offset = 180;
index = [];
bins = [];

data = reshape(data,1,[]);

if (isLossy)
    if (mod(numBins,2)==0)
        numBins=numBins+1;
    end
    
    bins = linspace(-1,1,numBins+2)*(offset*2);
    index = quantiz(data, bins);
    index = index+1;
    
    counts = zeros(1,numel(bins)-1);

    for i=1:numel(index)
        counts(index(i)) = counts(index(i))+1;
    end
else
    index = data+offset;

    counts = zeros(1,offset + 300);

    for i=1:numel(index)
        counts(index(i)) = counts(index(i))+1;
    end
end

counts=counts+1;

end