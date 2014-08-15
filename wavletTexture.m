function H = wavletTexture(I)
% Compute the 128-D wavelet transform feature
%
% Input:
% I: the input image
% Output:
% H: 128-D feature
%
% Reference:
% [1] NUS-WIDE: A Real-World Web Image Database from National University of
% Singapore

if ndims(I) > 2
    im = rgb2gray(I);
else
    im = I;
end

% Computer low-pass and high-pass filters
wname = 'db8';
[Lo_D, Hi_D, ~, ~] = wfilters(wname);

% PWT
scale = 3;
cA = im;
H1 = [];
for i = 1 : scale
	[c, s] = wavedec2(cA, 1, Lo_D, Hi_D);
	msize = s(1,1) * s(1,2);
	cA = c(1, 1 : msize);
	cA = reshape(cA, s(1,1), s(1,2));
    
	cH = c(1, msize + (1:msize));
	cV = c(1, 2*msize + (1:msize));
	cD = c(1, 3*msize + (1:msize));
    
	cH = reshape(cH, s(2,1), s(2,2));
	cV = reshape(cV, s(2,1), s(2,2));
	cD = reshape(cD, s(2,1), s(2,2));
	
	H1 = [H1 mean2((abs(cA))) std2(abs(cA)) mean2((abs(cH))) std2(abs(cH))...
        mean2((abs(cV))) std2(abs(cV)) mean2((abs(cD))) std2(abs(cD))];
end


set = [];
candidate = {};
H2 = [];
cA = im;
set{1} = cA; % store the frequency (LL,LH,HL) to be decomposed
candidate{1} = cA;
for j = 1 : scale
	count = 0;
	set = candidate;
	for i = 1 : length(set)
			cA = set{i};
			[c, s] = wavedec2(cA, 1, Lo_D, Hi_D);
			msize = s(1,1) * s(1,2);
			cA = c(1, 1 : msize);
			cA = reshape(cA, s(1,1), s(1,2));

			cH = c(1, msize + (1:msize));
			cV = c(1, 2*msize + (1:msize));
			cD = c(1, 3*msize + (1:msize));
            
			cH = reshape(cH, s(2,1), s(2,2));
			cV = reshape(cV, s(2,1), s(2,2));
			cD = reshape(cD, s(2,1), s(2,2));
			
            count = count + 1;
			candidate{count} = cA;
			count = count + 1;
			candidate{count} = cH;
			count = count + 1;
			candidate{count} = cV;
			
			H2 = [H2 mean2((abs(cA))) std2(abs(cA)) mean2((abs(cH))) std2(abs(cH))...
                mean2((abs(cV))) std2(abs(cV)) mean2((abs(cD))) std2(abs(cD))];
    end
end

H = [H1 H2];

