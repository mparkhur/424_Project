function [index,minmax,counts] = quantizeAndCount(data, numBins, isLossy, isMV)

if (size(data,1)>1)
    data = reshape(data,1,[]);
end

minmax = 0;

if (isMV)
    index = data+17;
    
    counts = zeros(1,33);

elseif (isLossy)
    if (mod(numBins,2)==0)
        numBins=numBins+1;
    end
    
    maxi = max(data);
    
    bins = linspace(-1,1,numBins+2)*(maxi+1);
    bins = bins(bins~=0);
    index = quantiz(data, bins);
    
    counts = zeros(1,numel(bins)-1);
    
    minmax = maxi;
else
    mini = min(data);
    
    index = data - mini + 1;

    counts = zeros(1,max(index));
    
    minmax = mini;
end

for i=1:numel(index)
        counts(index(i)) = counts(index(i))+1;
end

counts=counts+1;

clearvars -except index minmax counts;

end