function datadq = dequantize(data, bins, isLossy)

offset = 180;

if (isLossy)
    codebook = zeros(1,numel(bins)-1);

    for i=1:numel(bins)-1
        codebook(i) = (bins(i)+bins(i+1))/2;
    end

    datadq = codebook(data);
else
    datadq = data-offset;
end

end