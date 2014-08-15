function H = colorHist( I, bins )
% Compute color histogram in RGB color space
%
% Input:
% I: the input image
% bins: the number of bins per each channel
%
% Output:
% H: the color histogram with bins^3 dimensions


% default value of parameters
if(nargin < 2),  bins = 4;  end

m = size(I, 1);
n = size(I, 2);

% transform the grayscale image to the RGB image
if ndims(I) < 3
    I = repmat(I, [1, 3]);
    I = reshape(I, [m, n, 3]);
end

H = zeros(bins, bins, bins);
pixels = m * n;

I = reshape(I, [pixels, 3]);
sep = 256 / bins;
for i = 1 : pixels
    p = double(I(i, :));
    p = floor(p / sep) + 1;
    H(p(1), p(2), p(3)) = H(p(1), p(2), p(3)) + 1;
end

H = H(:)';
H = H ./ sum(H);


end
