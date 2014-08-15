function H = autoCorrelogram( I, distance )
% Compute the auto-correlogram vector for an input image in the HSV space
% 
% Input:
% I: the input image
% distance: a vector representing the different distances in which the
% color distribution is calculated
%
% Output:
% H: the resulting auto-correlogram vector
% 
% Reference
% [1] Image indexing using color correlograms
% [2] NUS-WIDE: a real-world web image database from National University of
% Singapore


% default value of paramters
if(nargin < 2),  distance = [1, 3, 5, 7];  end

m = size(I, 1);
n = size(I, 2);

dNum = length(distance); % the number of different distances considered
cNum = 36; % the number of color bins

H = zeros(cNum, dNum);

% transform the grayscale image to the RGB image
if ndims(I) < 3
    I = repmat(I, [1, 3]);
    I = reshape(I, [m, n, 3]);
end

% transform the RGB image to the HSV image
im = rgb2hsv(I);
% quantize the HSV color space into 36 non-uniform 36 bins
im = hsvQuantization(im);

% Generate all possible indices in the given image
[X, Y] = meshgrid(1 : m, 1 : n);
X = X(:);
Y = Y(:);

% count the number of pixels for each color
colorHist = zeros(cNum, 1);
for i = 0 : cNum - 1
    colorHist(i+1) = numel(im(im == i));
end
colorHist(colorHist == 0) = eps;


colors = im(sub2ind([m n], X, Y));


for k = 1 : dNum
    
    dis = distance(k);
    offset = computeOffset(dis);
    offNum = 8 * dis;
    
    % assert(size(offset, 1) == offNum);
    
    countPerColor = zeros(cNum, 1);
    
    % Compute the histogram by taking into account only a single offset
    for i = 1 : offNum
        off = offset(i, :);
        countPerColor = countPerColor + onOffset(im, m, n, X, Y, colors, off, cNum);   
    end
    
    countPerColor = countPerColor ./ colorHist;
    H(:, k) = countPerColor / offNum;
end

H = H(:)';
end

function offset = computeOffset(distance)
% Compute the offset indices for a given distance
    
    [X1, Y1] = meshgrid([-distance distance], -distance : distance);
    X1 = X1(:);
    Y1 = Y1(:);
    
    [X2, Y2] = meshgrid(-distance + 1 : distance - 1, [-distance distance]);
    X2 = X2(:);
    Y2 = Y2(:);
    
    offset = [X1 Y1; X2 Y2];
end

function countPerColor = onOffset(im, m, n, X, Y, colors, off, cNum)
% Count with a specific offset

    offX = X + off(1);
    offY = Y + off(2);
    
    ind = offX >= 1 & offX <= m & offY >= 1 & offY <= n;
    
    offX = offX(ind, :);
    offY = offY(ind, :);
    
    V = colors(ind, :);
    offV = im(sub2ind([m,n], offX, offY));
    
    ind = V == offV;
    V = V(ind);
    
    if isempty(V)
        countPerColor = zeros(cNum, 1);
    else
        countPerColor = accumarray(V+1, 1, [cNum 1]);
    end
end

