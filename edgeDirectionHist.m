function H = edgeDirectionHist( I, bins )
% Compute the edge direction histogram
%
% Input:
% I: the input image
% bins: the number of bins for directions
% 
% Output:
% H: the direction histogram with bins+1 dimensions, in which the last bin
% is related to non-edge points
%
% Reference:
% [1] Brief Descriptions of Visual Features for Baseline TRECVID Concept Detectors


% default value of parameters
if(nargin < 2),  bins = 72;  end

if ndims(I) > 2
    im = rgb2gray(I);
else
    im = I;
end

% use Sobel operator to calculate the direction by the gradient of each point
im = double(im);
h = -fspecial('sobel');
Gx = imfilter(im, h', 'replicate');
Gy = imfilter(im, h, 'replicate');

Gdir = atan2(-Gy, Gx) * 180 / pi;
ind = Gdir < 0;
Gdir(ind) = Gdir(ind) + 360;

% decide the bin of each pixel
sep = 360 / bins;
Gdir = floor(Gdir / sep) + 1;

% use Canny ﬁlter to detect edge points
BW = edge(im, 'canny');
total_num = numel(BW);
edge_num = sum(BW(:));
nonedge_num = total_num - edge_num;

% count for each bin
Gdir = Gdir(BW);
Gdir = Gdir(:);
H = accumarray(Gdir, 1, [bins 1]);
% normalize
H = H / edge_num;

% the last bin is related to non-edge points
H = [H; nonedge_num / total_num]';

end

