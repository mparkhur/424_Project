function pred = motionPrediction(prev,mv)

mvx = mv(:,:,1);
mvy = mv(:,:,2);

[height, width] = size(prev);
[x_length, y_length] = size(mvx);

blkx = ceil(height/x_length);
blky = ceil(width/y_length);

pred = zeros(height, width);

for i = 1:x_length
    for j = 1:y_length
        
        px = x + mvx(i, j);
        py = y + mvy(i, j);
        prev_block = prev(px:(px+blkx-1), py:(py+blky-1));
       
        pred(x:(x+blkx-1), y:(y+blky-1)) = prev_block;
       
   end
end

end