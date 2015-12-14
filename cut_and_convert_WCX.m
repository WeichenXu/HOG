% cut the input I from [160 96]to [128 64]
% convert RGB value to grayscale value F = 0.21 R + 0.72 G + 0.07 B
% Author: Weichen Xu
% Date: 12/14/2015
function I = cut_and_convert_WCX(I)
[rows, cols, channels] = size(I);
cut_off_r = (rows-128)/2;
cut_off_c = (cols-64)/2;
I = I(cut_off_r+1:rows-cut_off_r, cut_off_c+1:cols-cut_off_c,:);
% convert
if channels == 3
    I = 0.21*I(:,:,1) + 0.72*I(:,:,2) + 0.07*I(:,:,3);
end
end