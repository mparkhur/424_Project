function [index,minmax,counts] = quantizeAndCount(data, numBins, isLossy)

data = reshape(data,1,[]);

if (isLossy)
    if (mod(numBins,2)==0)
        numBins=numBins+1;
    end
    
    maxi = max(data);
    
    bins = linspace(-1,1,numBins+2)*(maxi+1);
    bins = bins(bins~=0);
    index = quantiz(data, bins);
    
    mi = min(index);
    ma = max(index);
    
    counts = zeros(1,numel(bins)-1);

    for i=1:numel(index)
        counts(index(i)) = counts(index(i))+1;
    end
    
    minmax = maxi;
else
    mini = min(data);
    
    index = data - mini + 1;

    counts = zeros(1,max(index));

    for i=1:numel(index)
        counts(index(i)) = counts(index(i))+1;
    end
    
    minmax = mini;
end

counts=counts+1;

end