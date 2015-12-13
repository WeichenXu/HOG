% Compute average descriptor for pos and neg
% train and test by linear classifier
% Author: Weichen Xu
% Date: 12/13/2015
clc;
clear;
%% Read pos&neg dir, compute HOG features
% read dir
train_pos_dir_path = '.\Images_P2\Training Set\Positive Samples';
train_neg_dir_path = '.\Images_P2\Training Set\Negative Samples';
test_pos_dir_path = '.\Images_P2\Testing Set\Positive Samples';
test_neg_dir_path = '.\Images_P2\Testing Set\Negative Samples';
train_pos_dir = dir(train_pos_dir_path);
train_neg_dir = dir(train_neg_dir_path);
test_pos_dir = dir(test_pos_dir_path);
test_neg_dir = dir(test_neg_dir_path);
% for each image, compute HOG
train_hog_features = [];
train_labels = [];
[train_pos_num,~] = size(train_pos_dir);
[train_neg_num,~] = size(train_neg_dir);
% read starting at 3 to exclude '.' & '..' in pos dir
for i=3:train_pos_num
    I = imread([train_pos_dir_path '\' train_pos_dir(i).name]);
    I_hog = hog_WCX(double(I));
    train_hog_features = [train_hog_features, I_hog];
    % set training label to 1 for positive
    train_labels = [train_labels 1];
    fprintf('%d positive training hog computation finished\n',i-2);
end
% read starting at 3 to exclude '.' & '..' in neg dir
for i=3:train_neg_num
    I = imread([train_neg_dir_path '\' train_neg_dir(i).name]);
    I_hog = hog_WCX(double(I));
    train_hog_features = [train_hog_features, I_hog];
    % set training label to 1 for positive
    train_labels = [train_labels -1];
    fprintf('%d negative training hog computation finished\n',i-2);
end
%% Compute mean descriptor for pos & neg, then calculate distance between each sample to corresponding mean
% compute mean descriptor
mean_pos_hog = mean(train_hog_features(:,train_labels==1),2);
mean_neg_hog = mean(train_hog_features(:,train_labels==-1),2);
% compute corresponding Euclidean distance
pos_euc_dis = sqrt(sum((train_hog_features(:,train_labels==1) - repmat(mean_pos_hog, 1, train_pos_num-2)).^2));
neg_euc_dis = sqrt(sum((train_hog_features(:,train_labels==-1) - repmat(mean_neg_hog, 1, train_pos_num-2)).^2));
%% Output to file, here I write to training_set_euclidean_dis.txt
