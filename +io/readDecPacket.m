function [fMax, iframe, rMax, residuals, mvs, bytesRead] = readDecPacket(outfile, numBins, dataDims, mvDims, rCounts, mvCounts, byteOffset)

if (mod(numBins,2)==0)
    numBins=numBins+1;
end

fid = fopen(outfile, 'rb');

% Move file pointer to relevant data
fseek(fid, byteOffset, 'bof');
bitsRead = 0;

%========= IFRAME =========

% fMax
fMax = fread(fid, 1, 'ubit10=>double');
bitsRead = bitsRead + 10;

% Total number of bits in fData
numBitsfData = fread(fid, 1, 'ubit32=>double');
bitsRead = bitsRead + 32;

% fCounts histogram
fCounts = fread(fid, numBins, 'ubit18=>double');
bitsRead = bitsRead + (18 * numBins);

% fData
enc_fdata = fread(fid, numBitsfData, 'ubit1');
bitsRead = bitsRead + numBitsfData;

%========= RESIDUALS =========

% rMax
rMax = fread(fid, 1, 'ubit10=>double');
bitsRead = bitsRead + 10;

% Total number of bits in rData
numBitsrData = fread(fid, 1, 'ubit32=>double');
bitsRead = bitsRead + 32;

% rData
enc_rdata = fread(fid, numBitsrData, 'ubit1');
bitsRead = bitsRead + numBitsrData; 

%========= MOTION VECTORS =========

% Total number of bits in mvData
numBitsmvData = fread(fid, 1, 'ubit18=>double');
bitsRead = bitsRead + 18;

% mvData
enc_mvdata = fread(fid, numBitsmvData, 'ubit1');
bitsRead = bitsRead + numBitsmvData; 

fclose(fid);

bytesRead = byteOffset + ceil(bitsRead/8);

fSize = dataDims(1)*dataDims(2);
rSize = (fSize*(dataDims(3)-1));
mvSize = prod(mvDims);

% Decode Data and mvs
f1 = parfeval(@arithdeco, 1, enc_fdata, fCounts, fSize);
f2 = parfeval(@arithdeco, 1, enc_rdata, rCounts, rSize);
f3 = parfeval(@arithdeco, 1, enc_mvdata, mvCounts, mvSize);

iframe = fetchOutputs(f1);
residuals = fetchOutputs(f2);
mvs = fetchOutputs(f3);

clearvars -except fMax iframe rMax residuals mvs bytesRead;

end