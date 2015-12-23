% Linear classifier, binary classifier
% Author: Weichen Xu
% Date: 12/13/2015
% linear_train: positive_set, negative_set
% linear_predict: predict_set, return lable
classdef linear_classifier_WCX < handle
    properties
        W;
        alpha;
    end
    methods
        % set initial training attributes
        function obj = linear_classifier_WCX(w, a)
            obj.W = w;
            obj.alpha = a;
        end
        % linear training
        function obj = linear_training_WCX(obj, pos, neg)
            %% init trainging set & training labels
            % positive: 1, negative: -1
            w = obj.W;
            w = [w, 1];
            [~,pos_size] = size(pos);
            [~,neg_size] = size(neg);
            % append row of 1s to last of feature as w*a+d*1
            pos(end+1,:) = ones;
            neg(end+1,:) = ones;
            Labels = zeros(pos_size+neg_size,1);
            Labels(1:pos_size,:) = 1;
            Labels(pos_size+1:pos_size+neg_size, :) = -1;
            Training_set = [pos neg];
            %% set training falg and start training
            train_finish = false;
            fprintf('Linear classifier start training\n');
            iteration = 0;
            while ~train_finish
                iteration = iteration + 1;
                train_finish = true;
                for i = 1:pos_size+neg_size
                    if Labels(i, 1)*w*Training_set(:,i) <= 0
                        train_finish = false;
                        %temp = Labels(i, 1)*obj.alpha*Training_set(:,i);
                        w = w+(obj.alpha*Labels(i, 1)*Training_set(:,i)).';
                    end
                end
            end
            fprintf('Linear classifier training finished, %d iterations\n', iteration);
            obj.W = w;
        end
        % linear predict
        
        % input: feature matrix, v*n by row size = vector size
        function predict_labels = linear_predict_WCX(obj, testing)
            % append 1s to end row of testing
            testing(end+1, :) = ones;
            predict_labels = testing.'*(obj.W)';
            predict_labels(predict_labels>0,:) = ones;
            predict_labels(predict_labels<0,:) = -ones;
        end
    end
    
end

