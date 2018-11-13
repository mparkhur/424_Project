function datadq = dequantize(data, minmax, isLossy, numBins, isMV)

if (isMV)
    datadq = data-17;

elseif (isLossy)
    maxi = minmax;
    
    if (mod(numBins,2)==0)
        numBins=numBins+1;
    end
    
    bins = linspace(-1,1,numBins+2)*(maxi+1);
    bins = bins(bins~=0);
    
    codebook = zeros(1,numel(bins)-1);

    for i=1:numel(bins)-1
        codebook(i) = (bins(i)+bins(i+1))/2;
    end

    datadq = codebook(data);
else
    mini = minmax;
    
    datadq = data - 1 + mini;
end

clearvars -except datadq;

end