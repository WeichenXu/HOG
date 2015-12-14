% Compute average descriptor for pos and neg
% train and test by linear classifier
% Author: Weichen Xu
% Date: 12/13/2015
function main()
clc;
clear;
%% Read pos&neg dir, compute HOG features
% read dir
images_dir = uigetdir('./');
train_pos_dir_path = [images_dir '\Training Set\Positive Samples'];
train_neg_dir_path = [images_dir '\Training Set\Negative Samples'];
test_pos_dir_path =  [images_dir '\Testing Set\Positive Samples'];
test_neg_dir_path =  [images_dir '\Testing Set\Negative Samples'];
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
    fprintf('No.%d positive training hog computation finished\n',i-2);
end
% read starting at 3 to exclude '.' & '..' in neg dir
for i=3:train_neg_num
    I = imread([train_neg_dir_path '\' train_neg_dir(i).name]);
    I_hog = hog_WCX(double(I));
    train_hog_features = [train_hog_features, I_hog];
    % set training label to 1 for positive
    train_labels = [train_labels -1];
    fprintf('No.%d negative training hog computation finished\n',i-2);
end
%% Compute mean descriptor for pos & neg, then calculate distance between each sample to corresponding mean
% compute mean descriptor
mean_pos_hog = mean(train_hog_features(:,train_labels==1),2);
mean_neg_hog = mean(train_hog_features(:,train_labels==-1),2);
% compute corresponding Euclidean distance
pos_euc_dis = sqrt(sum((train_hog_features(:,train_labels==1) - repmat(mean_pos_hog, 1, train_pos_num-2)).^2));
neg_euc_dis = sqrt(sum((train_hog_features(:,train_labels==-1) - repmat(mean_neg_hog, 1, train_pos_num-2)).^2));
%% Output to file, here I write to training_set_euclidean_dis.txt
txtFileName = 'training_set_euclidean_dis.txt';
fileID = fopen(txtFileName, 'w');
[~, train_set_size] = size(train_labels);
for i=1:train_set_size
    % write pos/neg, image_name, distance
    if train_labels(i) == 1
        fprintf(fileID, sprintf('Filename:%s Positive Euclidean_distance:%f\n', train_pos_dir(i+2).name, pos_euc_dis(i))); 
    else
        fprintf(fileID, sprintf('Filename:%s Negative Euclidean_distance:%f\n', train_neg_dir(i-train_pos_num+4).name, neg_euc_dis(i-train_pos_num+2))); 
    end
end
fprintf('Writing Euclidean distance to file:%s finished!\n', txtFileName);
fclose(fileID);

%% Linear classifier training
% init and set attributes of lienar classifier
[r, c] = size(train_hog_features);
w = zeros(r,1).';
linearClassifier = linear_classifier_WCX (w, 1);
%linearClassifier.W = w;
%linearClassifier.alpha = 0.1;
linearClassifier = linearClassifier.linear_training_WCX(train_hog_features(:,train_labels==1), train_hog_features(:,train_labels==-1));
predict_labels_for_train = linearClassifier.linear_predict_WCX(train_hog_features);
%% extract features of testing set 
test_hog_features = [];
% read starting at 3 to exclude '.' & '..' in pos dir
[test_pos_num,~] = size(test_pos_dir);
[test_neg_num,~] = size(test_neg_dir);
for i=3:test_pos_num
    I = imread([test_pos_dir_path '\' test_pos_dir(i).name]);
    I_hog = hog_WCX(double(I));
    test_hog_features = [test_hog_features, I_hog];
    fprintf('No.%d positive testing hog computation finished\n',i-2);
end
% read starting at 3 to exclude '.' & '..' in neg dir
for i=3:test_neg_num
    I = imread([test_neg_dir_path '\' test_neg_dir(i).name]);
    I_hog = hog_WCX(double(I));
    test_hog_features = [test_hog_features, I_hog];
    fprintf('No.%d negative testing hog computation finished\n',i-2);
end
%% test the linear classifier
% in predict_labels, 1 for classify as human, -1 otherwise
predict_labels = linearClassifier.linear_predict_WCX(test_hog_features);
% output predict_labels to a file
txtFileName = 'testing_set_predict_results.txt';
fileID = fopen(txtFileName, 'w');
[test_set_size, ~] = size(predict_labels);
for i=1:test_set_size
    if i<=test_pos_num-2
        fprintf(fileID, sprintf('Filename:%s Positive ', test_pos_dir(i+2).name)); 
    else
        fprintf(fileID, sprintf('Filename:%s Positive ', test_neg_dir(i-test_pos_num+4).name)); 
    end
    if predict_labels(i)>0
        fprintf(fileID, sprintf('Predict result: Positive\n'));
    else
        fprintf(fileID, sprintf('Predict result: Negative\n'));
    end
end
fprintf('Writing prediction results to file:%s finished!\n', txtFileName);
fclose(fileID);
end