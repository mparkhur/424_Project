function [qdata,maxi,counts] = quantizeiFrame(data, numBins)

if (mod(numBins,2)==0)
    numBins=numBins+1;
end

absd = abs(data);
maxi = ceil(max(max(absd)));

stepSizeCa = ceil((maxi*2)/numBins);
stepSizeDetail = stepSizeCa * 4;

% Detail

qdata = sign(data).*floor(absd./stepSizeDetail);

% CA

qdata(1:2:end,1:2:end) = sign(data(1:2:end,1:2:end)).*floor(absd(1:2:end,1:2:end)./stepSizeCa);

qdata = qdata + ceil(numBins/2);

% Counts
qdata = reshape(qdata,1,[]);

counts = zeros(1,numBins);

for i=1:numel(qdata)
        counts(qdata(i)) = counts(qdata(i))+1;
end

counts=counts+1;

clearvars -except qdata maxi counts;

end