function Nbits = encArith(message_int, histfile, outfile)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load(histfile, 'counts');

Nsymbols = length(message_int);
message_enc = arithenco(message_int, counts);
Nbits = length(message_enc);

outID = fopen(outfile, 'wb');
fwrite(outID, Nsymbols, 'uint32');
fwrite(outID, message_enc, 'ubit1');
fclose(outID);

clear counts;
clear Nsymbols;
clear message_enc;
clear outID;

end

