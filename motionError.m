function mcpr = motionError(prev,curr,mv)

mvx = mv(:,:,1);
mvy = mv(:,:,2);

[height, width] = size(curr);
[x_length, y_length] = size(mvx);

blkx = ceil(height/x_length);
blky = ceil(width/y_length);

mcpr = zeros(height, width);

for i = 1:x_length
    for j = 1:y_length
       
       x = (i-1)*blkx+1;
       y = (j-1)*blky+1;
       curr_block = curr(x:(x+blkx-1), y:(y+blky-1));
       
       px = x + mvx(i, j);
       py = y + mvy(i, j);
       prev_block = prev(px:(px+blkx-1), py:(py+blky-1));
       
       mcpr(x:(x+blkx-1), y:(y+blky-1)) = curr_block - prev_block;
       
   end
end

end