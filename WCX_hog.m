% HOG according to Dalal, CVPR, 2005
% Author: Weichen Xu, wx431@nyu.edu
% Date: 12/12/2015
% I: image window to extract hog feature
% CellSize = 8*8, BlockSize = 2*2 cells, Overlapping = 8, 
% Bin = 9, Normal_Method = L2
% hogs: computed hog features
function hogs = WCX_hog(I)
%testImage =[ '.\' 'test' '.bmp'];
%I = double(imread(testImage)); % to double for calculation accuracy
cellW = 8; cellH = 8;
bins = 9; binWidth = 180/bins;
blockH = 2; blockW = 2;
stride = 8; % overlapping
hogs = [];
% get image size
[rows, cols] = size(I);
%% Compute Im and Iangle
% Ir and Ic with canny
template = [-1 0 1];
Ic = correlation_WCX(I, template);
Ir = correlation_WCX(I, template.');
% Im and Iangle in X-Y coordinate
Im = round((sqrt(Ir.^2 + Ic.^2)/sqrt(2))); % normalize
Iangle = -atan2(double(Ir),double(Ic))*180/pi + 180; % invert to XY coord, from radian to angle
% set undefined border 
% m = 0, angle = -1
for i = 1:rows
    Im(i,1) = 0;
    Im(i,cols) = 0;
    Iangle(i,1) = -1;
    Iangle(i,cols) = -1;
end
for i = 1:cols
    Im(1,i) = 0;
    Im(rows,i) = 0;
    Iangle(1,i) = -1;
    Iangle(rows,i) = -1;
end
%% Accumulte gradient magnitude in bins for each cell
% initialize cells
cells = zeros(rows/cellH, cols/cellW, 9);
% accumulate histogram in cell for each point
for i = 0:rows/cellH-1
    for j = 0:cols/cellW-1
        for k = 1:cellH
            for m = 1:cellW
                % linear interpolation into two bins
                % except undefined borders
                if Iangle(i*cellH+k, j*cellW+m) >= 0
                    [sbin,weighted] = bin_interpolate_WCX(Iangle(i*cellH+k, j*cellW+m), binWidth, -1);
                    cells(i+1, j+1, sbin) = cells(i+1, j+1, sbin) + weighted*Im(i*cellH+k, j*cellW+m);
                    [lbin,weighted] = bin_interpolate_WCX(Iangle(i*cellH+k, j*cellW+m), binWidth, 1);
                    cells(i+1, j+1, lbin) = cells(i+1, j+1, sbin) + weighted*Im(i*cellH+k, j*cellW+m);
                end
            end
        end
    end
end
%% Concatenate cell features to get block, using overlapping & normalization
% calculate size of block array
blocks_rows = (rows - blockH*cellH)/stride+1;
blocks_cols = (cols - blockW*cellW)/stride+1;
% get each block feature by  concatenate corresponding cells, Row Major
for i=1:blocks_cols
    for j=1:blocks_rows
        block_hog = [];
        for k=1:blockW
            for m=1:blockH
                block_hog = [block_hog; reshape(cells((j-1)*(stride/cellH)+m, (i-1)*(stride/cellW)+k, :), bins, 1)];
            end
        end
        % normalize each block
        hogs = [hogs, normalize_L2_WCX(block_hog)];
    end
end
%% reshpae the hogs to one dimentional
[hogsR, hogsC] = size(hogs);
hogs = reshape(hogs, hogsR*hogsC, 1);
end