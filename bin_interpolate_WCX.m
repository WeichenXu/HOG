% linear interpolate bin number & weighted value for the angle
% angle [0, 360), mode -1,1
% if mode = -1, return the smaller bin number & weighted value
% if mode = 1, return the larger bin number & weighted value
% weighted value =  1 - (angle - bin_center)/binWidth
function [bin, weighted] = bin_interpolate_WCX(angle, binWidth, mode)
% convert angle to bin [1, 9]
angle = angle - 180*(floor(angle/180));
bin = floor(angle/binWidth)+1;
%bin_left = 0,bin_right = 0;
% find left bin, by comparing with current bin center
bin_center = binWidth*((bin-1)+0.5);
if angle < bin_center
    bin_s = bin-1;
    bin_l = bin;
else
    bin_s= bin;
    bin_l = bin+1;
end
if mode < 0 % return smaller bin weighted value
    bin = bin_s;
else
    bin = bin_l;
end
% special case when bin = 0, 10 to normal
bin_center = bin*binWidth - binWidth/2;
if bin == 0
    bin = 9;
elseif bin == 10
    bin = 1;
end

weighted = 1-abs(angle - bin_center)/binWidth;
end