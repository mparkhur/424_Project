function mv = motionEstimation(prev, curr, blkx, blky, search_range)

% Half Pixel Stuff
search_range = 2*search_range;
blkx = 2*blkx;
blky = 2*blky;

curr = imresize(curr, 2);
prev = imresize(prev, 2);
%====

[height, width] = size(curr);

x_length = height / blkx;
y_length = width / blky;

mvx = zeros(x_length, y_length);
mvy = mvx;

for i = 1:x_length
    for j = 1:y_length
       
       SAD = inf;
       
       cx = (i-1)*blkx+1;
       cy = (j-1)*blky+1;
       curr_block = curr(cx:(cx+blkx-1), cy:(cy+blky-1));
       
       for m = -search_range:search_range
           for n = -search_range:search_range
               
               px = cx + m;
               py = cy + n;
               
               if (px < 1) || (py < 1) || (px+blkx-1 > height) || (py+blky-1 > width)
                   continue;
               end
               
               prev_block = prev(px:(px+blkx-1), py:(py+blky-1));
               
               newSAD = sum(sum((curr_block - prev_block).^2))/numel(curr_block);
               
               if (newSAD < SAD)
                   
                   SAD = newSAD;
                   mvx(i,j) = m;
                   mvy(i,j) = n;
               
               end
           end
       end
   end
end

mv(:,:,1) = mvx;
mv(:,:,2) = mvy;

end
