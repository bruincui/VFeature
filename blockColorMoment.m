function H = blockColorMoment( I, gridNum )
% Compute the block-wise color moments based on the LAB space
%
% Input:
% I: the raw RGB image 
% gridNum: the grid partition constant
%
% Output:
% H: the color moment vector with the dimension of partition^2 * 3 * 3
%
% Reference:
% [1] NUS-WIDE: A Real-World Web Image Database from National University of
% Singapore

% default value of paramters
if(nargin < 2),  gridNum = 5;  end

m = size(I, 1);
n = size(I, 2);

% transform the grayscale image to the RGB image
if ndims(I) < 3
    I = repmat(I, [1, 3]);
    I = reshape(I, [m, n, 3]);
end

% transform the RGB image to the LAB image
im = rgb2lab(I);

if min(m, n) < gridNum
    error('The grid number exceeds the image size!')
end

H = zeros(3 * 3, gridNum * gridNum);

block_x_size = floor(m / gridNum);
block_y_size = floor(n / gridNum);

count = 0;
for i = 1 : gridNum
    for j = 1 : gridNum
        
        count = count + 1;
        
        % pointer to the block
        r = block_x_size * (i - 1) + 1;
        c = block_y_size * (j - 1) + 1;
        
        block = im(r : r + block_x_size -1, c : c + block_y_size - 1, :);
        
        H(1:3, count) = handleBlock(block(:, :, 1));
        H(4:6, count) = handleBlock(block(:, :, 2));
        H(7:9, count) = handleBlock(block(:, :, 3));
    end
end

H = H(:)';

end

function h = handleBlock(block)
    
    h = zeros(3, 1);
    
    block = block(:);
    
    h(1) = mean(block);
    h(2) = std(block);
    
    tmp = mean((block - h(1)).^3);
    h(3) = sign(tmp) * abs(tmp) ^ (1/3); % avoid the results with complex number
end

