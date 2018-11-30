function convertYUVtoY

import io.*;

size = [288 352 3];

frames = zeros(288,352,300);

for i = 1:150
    packet = readFrameBlock('foreman_cif.yuv', size, i);
    packet = double(packet);

    one = packet(:,:,1);
    two(1:144,:) = packet(145:288,:,2);
    two(145:288,:) = packet(1:144,:,3);

    x = (i-1)*2+1;
    frames(:,:,x) = one;
    frames(:,:,x+1) = two;

    % figure;
    % for i = 1:2
    %     subplot(1,2,i);
    %     imshow(uint8(frames(:,:,i)));
    % end

end

writeFrames(frames, 'foreman_cif.y');

end