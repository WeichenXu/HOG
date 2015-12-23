% output hog feature to a .txt file
% format: block feature line by line
% Author: Weichen Xu
% Date: 12/23/2015


function write2file_WCX(hog, txtName)
fid = fopen(txtName, 'w+');
for i=1:size(hog, 2)
    fprintf(fid, '%.2f ', hog(:,i));
    fprintf(fid, '\n');
end
fclose(fid);
end