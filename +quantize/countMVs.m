function counts = countMVs(qdata)
    
counts = zeros(1,65);

for i=1:numel(qdata)
        counts(qdata(i)) = counts(qdata(i))+1;
end

counts=counts+1;

clearvars -except counts;

end