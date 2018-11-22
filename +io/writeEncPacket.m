function writeEncPacket(fMax, fCounts, fData, rMax, rCounts, rData, mvCounts, mvData, outfile)

bitsWritten = 0;

% Encode Data and mvs
f1 = parfeval(@arithenco, 1, fData, fCounts);
f2 = parfeval(@arithenco, 1, rData, rCounts);
f3 = parfeval(@arithenco, 1, mvData, mvCounts);
%enc_fdata = arithenco(fData, fCounts);
%enc_rdata = arithenco(rData, rCounts);
%enc_mvdata = arithenco(mvData, mvCounts);

enc_fdata = fetchOutputs(f1);
enc_rdata = fetchOutputs(f2);
enc_mvdata = fetchOutputs(f3);

fid = fopen(outfile, 'ab');

%========= IFRAME =========

% fMax
fwrite(fid, fMax, 'ubit10');
bitsWritten = bitsWritten + 10;

% Total number of bits in fData
fwrite(fid, numel(enc_fdata), 'ubit32');
bitsWritten = bitsWritten + 32;

% fCounts histogram
fwrite(fid, fCounts, 'ubit16');
bitsWritten = bitsWritten + (16 * numel(fCounts));

% fData
fwrite(fid, enc_fdata, 'ubit1');
bitsWritten = bitsWritten + numel(enc_fdata);

%========= RESIDUALS =========

% rMax
fwrite(fid, rMax, 'ubit10');
bitsWritten = bitsWritten + 10;

% Total number of bits in rData
fwrite(fid, numel(enc_rdata), 'ubit32');
bitsWritten = bitsWritten + 32;

% rData
fwrite(fid, enc_rdata, 'ubit1');
bitsWritten = bitsWritten + numel(enc_rdata); 

%========= MOTION VECTORS =========

% Total number of bits in mvData
fwrite(fid, numel(enc_mvdata), 'ubit16');
bitsWritten = bitsWritten + 16;

% mvData
fwrite(fid, enc_mvdata, 'ubit1');
bitsWritten = bitsWritten + numel(enc_mvdata); 

padding = mod(bitsWritten, 8);

if (padding ~= 0)
    for i=1:(8-padding)
        fwrite(fid, 0, 'ubit1');
    end
end

fclose(fid);

clearvars;

end