function Qim = hsvQuantization( hsvI )
% Quantizing the HSV color space into 36 non-uniform 36 bins
% 
% Input:
% hsvI: the input image represented in the HSV space
%
% Output:
% Qim: the resulting quantized image with 36 dimensions
%
% Reference:
% [1] A CBIR method based on color-spatial feature

H = hsvI(:, :, 1) * 360;
S = hsvI(:, :, 2);
V = hsvI(:, :, 3);

Qim = zeros(size(H));

% rule 1
index = V >= 0.0 & V <= 0.2;
Qim(index) = 0;

% rule 2
index = (S >= 0.0 & S <= 0.2) & (V > 0.2 & V < 0.8);
Qim(index) = floor((V(index) - 0.2) * 10) + 1;

% rule 3
index = (S >= 0.0 & S <= 0.2) & (V >= 0.8 & V <= 1.0);
Qim(index) = 7;

% rule 4
index = (S > 0.2 & S <= 1.0) & (V > 0.2 & V <= 1.0);
hComp = hRule(H(index));
sComp = sRule(S(index));
vComp = vRule(V(index));
Qim(index) = 4 * hComp + 2 * sComp + vComp + 8;
end

function hComp = hRule(hValue)

    count = length(hValue);
    hComp = zeros(count, 1);
    
    for i = 1 : count
        hv = hValue(i);
        
        if hv > 22 && hv <= 45
            hComp(i) = 1;
        elseif hv > 45 && hv <= 70
            hComp(i) = 2;
        elseif hv > 70 && hv <= 155
            hComp(i) = 3;
        elseif hv > 155 && hv <= 186
            hComp(i) = 4;
        elseif hv > 186 && hv <= 278
            hComp(i) = 5;
        elseif hv > 278 && hv <= 330
            hComp(i) = 6;
        else
            hComp(i) = 0;
        end
    end
end


function sComp = sRule(sValue)
    sComp = zeros(size(sValue));
    ind = sValue > 0.65;
    sComp(ind) = 1;
end

function vComp = vRule(vValue)
    vComp = zeros(size(vValue));
    ind = vValue > 0.7;
    vComp(ind) = 1;
end
