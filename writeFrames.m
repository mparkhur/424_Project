function writeFrames(frames, outfile)

numFrames = size(frames, 3);

fid = fopen(outfile, 'a');

for i = 1:numFrames
    frame = reshape(frames(:,:,i)', [], 1);
    fwrite(fid, frame, 'ubit8');
end

fclose(fid);

clearvars;

end