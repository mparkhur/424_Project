function pred = motionPrediction(prev,mv)

% Half Pixel Stuff
prev = imresize(prev, 2);
%====

mvx = mv(:,:,1);
mvy = mv(:,:,2);

[height, width] = size(prev);
[x_length, y_length] = size(mvx);

blkx = height/x_length;
blky = width/y_length;

pred = zeros(height, width);

for i = 1:x_length
    for j = 1:y_length
        
        x = (i-1)*blkx+1;
        y = (j-1)*blky+1;
        
        px = x + mvx(i, j);
        py = y + mvy(i, j);
        prev_block = prev(px:(px+blkx-1), py:(py+blky-1));
       
        pred(x:(x+blkx-1), y:(y+blky-1)) = prev_block;
       
   end
end

pred = imresize(pred, 0.5);

end