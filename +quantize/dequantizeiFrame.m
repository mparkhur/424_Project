function data = dequantizeiFrame(qdata, maxi, numBins, frameDims)

qdata = reshape(qdata,frameDims(1),frameDims(2));

if (mod(numBins,2)==0)
    numBins=numBins+1;
end

stepSizeCa = ceil((maxi*2)/numBins);
stepSizeDetail = stepSizeCa * 4;

qdata = qdata - ceil(numBins/2);

% Detail

data = qdata.*stepSizeDetail;

% CA

data(1:2:end,1:2:end) = qdata(1:2:end,1:2:end).*stepSizeCa;

clearvars -except data;

end