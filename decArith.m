function message_dec_int = decArith(histfile,infile)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
load(histfile, 'counts');

inID = fopen(infile, 'rb');
Nsymbols = fread(inID, 1, 'uint32');
bitstream = fread(inID, 'ubit1');
fclose(inID);

message_dec_int = arithdeco(bitstream, counts, Nsymbols);

clear counts;
clear Nsymbols;
clear bitstream;
clear inID;

end


