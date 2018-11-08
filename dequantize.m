function datadq = dequantize(data, bins)

codebook = zeros(1,numel(bins)-1);

for i=1:numel(bins)-1
    codebook(i) = (bins(i)+bins(i+1))/2;
end

datadq = codebook(data);

end